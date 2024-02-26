local config = require('orgmode.config')
local colors = require('orgmode.colors')
local M = {}

function M.define_highlights()
  M.link_highlights()
  M.define_agenda_colors()
  M.define_org_todo_keyword_colors()
  M.define_todo_keyword_faces()
end

function M.link_highlights()
  local links = {
    -- Headlines
    ['@org.headline.level1'] = 'Title',
    ['@org.headline.level2'] = 'Constant',
    ['@org.headline.level3'] = 'Identifier',
    ['@org.headline.level4'] = 'Statement',
    ['@org.headline.level5'] = 'PreProc',
    ['@org.headline.level6'] = 'Type',
    ['@org.headline.level7'] = 'Special',
    ['@org.headline.level8'] = 'String',

    ['@org.priority.highest'] = '@comment.error',

    -- Headline tags
    ['@org.tag'] = '@tag.attribute',

    -- Headline plan
    ['@org.plan'] = 'Constant',

    -- Timestamps
    ['@org.timestamp.active'] = '@keyword',
    ['@org.timestamp.inactive'] = '@comment',
    -- Lists/Checkboxes
    ['@org.bullet'] = '@markup.list',
    ['@org.checkbox'] = '@markup.list.unchecked',
    ['@org.checkbox.halfchecked'] = '@markup.list.unchecked',
    ['@org.checkbox.checked'] = '@markup.list.checked',

    -- Drawers
    ['@org.properties'] = '@property',
    ['@org.properties.name'] = '@property',
    ['@org.drawer'] = '@property',

    ['@org.comment'] = '@comment',
    ['@org.directive'] = '@comment',
    ['@org.block'] = '@comment',

    -- Markup
    ['@org.bold'] = '@markup.strong',
    ['@org.bold.delimiter'] = '@markup.strong',
    ['@org.italic'] = '@markup.italic',
    ['@org.italic.delimiter'] = '@markup.italic',
    ['@org.strikethrough'] = '@markup.strikethrough',
    ['@org.strikethrough.delimiter'] = '@markup.strikethrough',
    ['@org.underline'] = '@markup.underline',
    ['@org.underline.delimiter'] = '@markup.underline',
    ['@org.code'] = '@markup.raw',
    ['@org.code.delimiter'] = '@markup.raw',
    ['@org.verbatim'] = '@markup.raw',
    ['@org.verbatim.delimiter'] = '@markup.raw',
    ['@org.hyperlink'] = '@markup.link.url',
    ['@org.latex'] = '@markup.math',
    ['@org.latex_env'] = '@markup.environment',
    -- Other
    ['@org.table.delimiter'] = '@punctuation.special',
    ['@org.table.heading'] = '@markup.heading',
    ['@org.edit_src'] = 'Visual',
  }

  for src, def in pairs(links) do
    vim.cmd(string.format([[hi def link %s %s]], src, def))
  end
end

function M.define_agenda_colors()
  local keyword_colors = colors.get_todo_keywords_colors()
  local c = {
    deadline = '@org.agenda.deadline',
    ok = '@org.agenda.scheduled',
    warning = '@org.agenda.scheduled_past',
  }
  for type, hlname in pairs(c) do
    vim.cmd(
      string.format('hi default %s guifg=%s ctermfg=%s', hlname, keyword_colors[type].gui, keyword_colors[type].cterm)
    )
  end

  M.define_org_todo_keyword_colors()
end

function M.define_org_todo_keyword_colors()
  local keyword_colors = colors.get_todo_keywords_colors()
  vim.cmd(
    ('hi default @org.keyword.todo guifg=%s ctermfg=%s gui=bold cterm=bold'):format(
      keyword_colors.TODO.gui,
      keyword_colors.TODO.cterm
    )
  )

  vim.cmd(
    ('hi default @org.keyword.done guifg=%s ctermfg=%s gui=bold cterm=bold'):format(
      keyword_colors.DONE.gui,
      keyword_colors.DONE.cterm
    )
  )
  vim.cmd([[hi default @org.leading_stars ctermfg=0 guifg=bg]])
end

function M.define_todo_keyword_faces()
  local opts = {
    underline = {
      type = vim.o.termguicolors and 'gui' or 'cterm',
      valid = 'on',
      result = 'underline',
    },
    weight = {
      type = vim.o.termguicolors and 'gui' or 'cterm',
      valid = 'bold',
    },
    foreground = {
      type = vim.o.termguicolors and 'guifg' or 'ctermfg',
    },
    background = {
      type = vim.o.termguicolors and 'guibg' or 'ctermbg',
    },
    slant = {
      type = vim.o.termguicolors and 'gui' or 'cterm',
      valid = 'italic',
    },
  }

  local result = {}

  for name, values in pairs(config.org_todo_keyword_faces) do
    local parts = vim.split(values, ':', { plain = true })
    local hl_opts = {}
    for _, part in ipairs(parts) do
      local faces = vim.split(vim.trim(part), ' ')
      if #faces == 2 then
        local opt_name = vim.trim(faces[1])
        local opt_value = vim.trim(faces[2])
        opt_value = opt_value:gsub('^"*', ''):gsub('"*$', '')
        local opt = opts[opt_name]
        if opt and (not opt.valid or opt.valid == opt_value) then
          if not hl_opts[opt.type] then
            hl_opts[opt.type] = {}
          end
          table.insert(hl_opts[opt.type], opt.result or opt_value)
        end
      end
    end
    if not vim.tbl_isempty(hl_opts) then
      local hl_name = '@org.keyword.face.' .. name:gsub('%-', '')
      local hl = ''
      for hl_item, hl_values in pairs(hl_opts) do
        hl = hl .. ' ' .. hl_item .. '=' .. table.concat(hl_values, ',')
      end
      vim.cmd(string.format('hi default %s %s', hl_name, hl))
      result[name] = hl_name
    end
  end

  return result
end

---@return table<string, string>
function M.get_agenda_hl_map()
  local faces = M.define_todo_keyword_faces()
  return vim.tbl_extend('force', {
    TODO = '@org.keyword.todo',
    DONE = '@org.keyword.done',
    deadline = '@org.agenda.deadline',
    ok = '@org.agenda.scheduled',
    warning = '@org.agenda.scheduled_past',
    priority = config:get_priorities(),
  }, faces)
end

return M
