local utils = require('orgmode.utils')
local config = require('orgmode.config')
local Templates = require('orgmode.capture.templates')
local ClosingNote = require('orgmode.capture.closing_note')
local Menu = require('orgmode.ui.menu')
local Range = require('orgmode.files.elements.range')
local CaptureWindow = require('orgmode.capture.window')
local Date = require('orgmode.objects.date')

---@class OrgProcessCaptureOpts
---@field source_file OrgFile
---@field source_headline? OrgHeadline
---@field destination_file OrgFile
---@field destination_headline? OrgHeadline
---@field template? OrgCaptureTemplate
---@field lines? string[]
---@field message? string

---@class OrgCapture
---@field templates OrgCaptureTemplates
---@field closing_note OrgClosingNote
---@field files OrgFiles
---@field _window OrgCaptureWindow
local Capture = {}

---@param opts { files: OrgFiles }
function Capture:new(opts)
  opts = opts or {}
  local data = {}
  data.files = opts.files
  data.templates = Templates:new()
  data.closing_note = ClosingNote:new()
  setmetatable(data, self)
  self.__index = self
  return data
end

---@param base_key string
---@param templates table<string, OrgCaptureTemplate>
function Capture:_get_subtemplates(base_key, templates)
  local subtemplates = {}
  for key, template in pairs(templates) do
    if string.len(key) > 1 and string.sub(key, 1, 1) == base_key then
      subtemplates[string.sub(key, 2, string.len(key))] = template
    end
  end
  return subtemplates
end

---@param templates table<string, OrgCaptureTemplate>
function Capture:_create_menu_items(templates)
  local menu_items = {}
  for key, template in pairs(templates) do
    if string.len(key) == 1 then
      local item = {
        key = key,
      }
      if type(template) == 'string' then
        item.label = template .. '...'
        item.action = function()
          self:_create_prompt(self:_get_subtemplates(key, templates))
        end
      elseif vim.tbl_count(template.subtemplates) > 0 then
        item.label = template.description .. '...'
        item.action = function()
          self:_create_prompt(template.subtemplates)
        end
      else
        item.label = template.description
        item.action = function()
          return self:open_template(template)
        end
      end
      table.insert(menu_items, item)
    end
  end
  return menu_items
end

---@param templates table<string, OrgCaptureTemplate>
function Capture:_create_prompt(templates)
  local menu = Menu:new({
    title = 'Select a capture template',
    items = self:_create_menu_items(templates),
    prompt = 'Template key',
  })
  menu:add_separator()
  menu:add_option({ label = 'Quit', key = 'q' })
  menu:add_separator({ icon = ' ', length = 1 })
  return menu:open()
end

function Capture:prompt()
  self:_create_prompt(self.templates:get_list())
end

---@param template OrgCaptureTemplate
---@return OrgCaptureWindow
function Capture:open_template(template)
  self._window = CaptureWindow:new({
    template = template,
    on_open = function()
      return config:setup_mappings('capture')
    end,
    on_close = function()
      return self:on_refile_close()
    end,
  })

  return self._window:open()
end

---@param shortcut string
function Capture:open_template_by_shortcut(shortcut)
  local template = self.templates:get_list()[shortcut]
  if not template then
    return utils.echo_error('No capture template with shortcut ' .. shortcut)
  end
  return self:open_template(template)
end

function Capture:on_refile_close()
  local is_modified = vim.bo.modified
  local opts = self:_get_refile_vars()
  if not opts then
    return
  end
  if is_modified then
    local choice =
      vim.fn.confirm(string.format('Do you want to refile this to %s?', opts.destination_file.filename), '&Yes\n&No')
    vim.cmd([[redraw!]])
    if choice ~= 1 then
      return utils.echo_info('Canceled.')
    end
  end

  vim.defer_fn(function()
    self:process_refile(opts)
    self._window = nil
  end, 0)
end

---Triggered when refiling from capture buffer
function Capture:refile()
  local opts = self:_get_refile_vars()
  if not opts then
    return
  end

  self:process_refile(opts)
  self:kill()
end

---Triggered when refiling to destination from capture buffer
function Capture:refile_to_destination()
  local source_file = self.files:get_current_file()
  local source_headline = source_file:get_headlines()[1]
  local destination = self:get_destination()
  self:process_refile({
    source_file = source_file,
    source_headline = source_headline,
    destination_file = destination.file,
    destination_headline = destination.headline,
    template = self._window.template,
  })
  self:kill()
end

---@private
---@return OrgProcessCaptureOpts | false
function Capture:_get_refile_vars()
  local target = self._window.template.target
  local file = vim.fn.resolve(vim.fn.fnamemodify(target, ':p'))

  if vim.fn.filereadable(file) == 0 then
    local choice = vim.fn.confirm(('Refile destination %s does not exist. Create now?'):format(file), '&Yes\n&No')
    if choice ~= 1 then
      utils.echo_error('Cannot proceed without a valid refile destination')
      return false
    end
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':h'), 'p')
    vim.fn.writefile({}, file)
  end

  local source_file = self.files:get_current_file()
  local source_headline = source_file:get_headlines()[1]
  local destination_file = self.files:get(file)
  local destination_headline = nil
  if self._window.template.headline then
    destination_headline = destination_file:find_headline_by_title(self._window.template.headline)
    if not destination_headline then
      utils.echo_error(('Refile headline "%s" does not exist in "%s"'):format(self._window.template.headline, file))
      return false
    end
  end

  return {
    source_file = source_file,
    source_headline = source_headline,
    destination_file = destination_file,
    destination_headline = destination_headline,
    template = self._window.template,
  }
end

---@param opts OrgProcessCaptureOpts
function Capture:process_refile(opts)
  opts.source_file:reload_sync()
  local is_same_file = opts.source_file.filename == opts.destination_file.filename

  local target_level = 0
  local target_line = -1

  if opts.destination_headline then
    target_level = opts.destination_headline:get_level()
    target_line = opts.destination_headline:get_range().end_line
  end

  local lines = opts.lines

  if not lines then
    lines = opts.source_file.lines

    if opts.source_headline then
      lines = opts.source_headline:get_lines()
      if opts.destination_headline or opts.source_headline:get_level() > 1 then
        lines = self:_adapt_headline_level(opts.source_headline, target_level, is_same_file)
      end
    end
  end

  if opts.template then
    lines = opts.template:apply_properties_to_lines(lines)
  end

  if is_same_file and not opts.source_headline then
    utils.echo_error('Cannot refile within a same file without a source headline')
    return false
  end

  self.files
    :update_file(opts.destination_file.filename, function(file)
      if file.filename == opts.source_file.filename then
        local item_range = opts.source_headline:get_range()
        return vim.cmd(string.format('silent! %d,%d move %s', item_range.start_line, item_range.end_line, target_line))
      end

      local range = self:_get_destination_range_without_empty_lines(Range.from_line(target_line))
      vim.api.nvim_buf_set_lines(0, range.start_line, range.end_line, false, lines)
    end)
    :wait()

  if not is_same_file and opts.source_headline and opts.source_headline.file.filename == utils.current_file_path() then
    local item_range = opts.source_headline:get_range()
    vim.api.nvim_buf_set_lines(0, item_range.start_line - 1, item_range.end_line, false, {})
  end

  utils.echo_info(opts.message or string.format('Wrote %s', opts.destination_file.filename))
  return true
end

---Triggered from org file when we want to refile headline
function Capture:refile_headline_to_destination()
  local file = self.files:get_current_file()
  local headline = file:get_closest_headline()
  local destination = self:get_destination()
  return self:process_refile({
    source_file = file,
    source_headline = headline,
    destination_file = destination.file,
    destination_headline = destination.headline,
    template = self._window.template,
  })
end

---@param headline OrgHeadline
function Capture:refile_file_headline_to_archive(headline)
  local file = headline.file

  if file:is_archive_file() then
    return utils.echo_warning('This file is already an archive file.')
  end

  local archive_location = file:get_archive_file_location()
  if not archive_location then
    return
  end

  local archive_directory = vim.fn.fnamemodify(archive_location, ':p:h')
  if vim.fn.isdirectory(archive_directory) == 0 then
    vim.fn.mkdir(archive_directory, 'p')
  end
  if not vim.loop.fs_stat(archive_location) then
    vim.fn.writefile({}, archive_location)
  end
  local start_line = headline:get_range().start_line
  local lines = headline:get_lines()
  local properties_node = headline:get_properties()
  local append_line = headline:get_append_line() - start_line
  local indent = headline:get_indent()

  local archive_props = {
    ('%s:ARCHIVE_TIME: %s'):format(indent, Date.now():to_string()),
    ('%s:ARCHIVE_FILE: %s'):format(indent, file.filename),
    ('%s:ARCHIVE_CATEGORY: %s'):format(indent, headline:get_category()),
    ('%s:ARCHIVE_TODO: %s'):format(indent, headline:get_todo() or ''),
  }

  if properties_node then
    local front_lines = { unpack(lines, 1, append_line) }
    local back_lines = { unpack(lines, append_line + 1, #lines) }
    lines = vim.list_extend(front_lines, archive_props)
    lines = vim.list_extend(lines, back_lines)
  else
    local front_lines = { unpack(lines, 1, append_line + 1) }
    local back_lines = { unpack(lines, append_line + 2, #lines) }
    table.insert(front_lines, ('%s:PROPERTIES:'):format(indent))
    lines = vim.list_extend(front_lines, archive_props)
    table.insert(lines, ('%s:END:'):format(indent))
    lines = vim.list_extend(lines, back_lines)
  end

  local destination_file = self.files:get(archive_location)

  return self:process_refile({
    source_file = headline.file,
    source_headline = headline,
    destination_file = destination_file,
    lines = lines,
    message = ('Archived to %s'):format(destination_file.filename),
  })
end

---@param item OrgHeadline
---@param target_level integer
---@param is_same_file boolean
function Capture:_adapt_headline_level(item, target_level, is_same_file)
  -- Refiling in same file just moves the lines from one position
  -- to another,so we need to apply demote instantly
  local level = item:get_level()
  if target_level == 0 then
    return item:promote(level - 1, true, not is_same_file)
  end
  if level <= target_level then
    return item:demote(target_level - level + 1, true, not is_same_file)
  end
  return item:promote(level - target_level - 1, true, not is_same_file)
end

--- Modify provided range to overwrite empty lines in the destination range
--- Example destination file:
--- ------------
--- * Headline 1
---
---
--- * Headline 2
--- ------------
--- Refiling "Headline 3" to "Headline 1" will remove empty line and we get this:
--- ------------
--- * Headline 1
--- ** Headline 3
--- * Headline 2
--- ------------
function Capture:_get_destination_range_without_empty_lines(range)
  local line_count = vim.api.nvim_buf_line_count(0)

  local end_line = range.end_line
  if end_line < 0 then
    end_line = end_line + line_count + 1
  end

  local start_line = end_line - 1

  local is_line_empty = function(row)
    local line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
    line = vim.trim(line)
    return #line == 0
  end

  while start_line >= 0 and is_line_empty(start_line) do
    start_line = start_line - 1
  end
  start_line = start_line + 1

  while end_line < line_count and is_line_empty(end_line) do
    end_line = end_line + 1
  end

  range.start_line = start_line
  range.end_line = end_line
  return range
end

--- Prompt for file (and headline) where to refile to
--- @return { file: OrgFile, headline?: OrgHeadline}
function Capture:get_destination()
  ---@type table<string, OrgFile>
  local valid_destinations = {}
  for _, file in ipairs(self.files:filenames()) do
    valid_destinations[vim.fn.fnamemodify(file, ':t')] = file
  end

  local destination = vim.fn.OrgmodeInput('Enter destination: ', '', function(arg_lead)
    return self:autocomplete_refile(arg_lead)
  end)
  destination = vim.split(destination, '/', { plain = true })

  if not valid_destinations[destination[1]] then
    utils.echo_error(
      ('"%s" is not a is not a file specified in the "org_agenda_files" setting. Refiling cancelled.'):format(
        destination[1]
      )
    )
    return {}
  end

  local destination_file = self.files:get(valid_destinations[destination[1]])
  local result = {
    file = destination_file,
  }
  local headline_title = table.concat({ unpack(destination, 2) }, '/')

  if not headline_title or vim.trim(headline_title) == '' then
    return result
  end

  local headlines = vim.tbl_filter(function(item)
    local pattern = '^' .. vim.pesc(headline_title:lower()) .. '$'
    return item:get_title():lower():match(pattern)
  end, destination_file:get_opened_unfinished_headlines())

  if not headlines[1] then
    utils.echo_error(
      ("'%s' is not a valid headline in '%s'. Refiling cancelled."):format(headline_title, destination_file.filename)
    )
    return {}
  end

  return {
    file = destination_file,
    headline = headlines[1],
  }
end

---@param arg_lead string
---@return string[]
function Capture:autocomplete_refile(arg_lead)
  local valid_filenames = {}
  for _, filename in ipairs(self.files:filenames()) do
    valid_filenames[vim.fn.fnamemodify(filename, ':t') .. '/'] = filename
  end

  if not arg_lead then
    return vim.tbl_keys(valid_filenames)
  end
  local parts = vim.split(arg_lead, '/', { plain = true })

  local selected_file = valid_filenames[parts[1] .. '/']

  if not selected_file then
    return vim.tbl_filter(function(file)
      return file:match('^' .. vim.pesc(parts[1]))
    end, vim.tbl_keys(valid_filenames))
  end

  local agenda_file = self.files:get(selected_file)
  if not agenda_file then
    return {}
  end

  local headlines = agenda_file:get_opened_unfinished_headlines()
  local result = vim.tbl_map(function(headline)
    return string.format('%s/%s', vim.fn.fnamemodify(headline.file.filename, ':t'), headline:get_title())
  end, headlines)

  return vim.tbl_filter(function(item)
    return item:match(string.format('^%s', vim.pesc(arg_lead)))
  end, result)
end

function Capture:kill()
  if self._window then
    self._window:kill()
    self._window = nil
  end
end

return Capture
