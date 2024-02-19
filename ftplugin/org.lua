if vim.b.did_ftplugin then
  return
end
---@diagnostic disable-next-line: inject-field
vim.b.did_ftplugin = true

local config = require('orgmode.config')
local utils = require('orgmode.utils')

config:setup_mappings('org')
config:setup_mappings('text_objects')
config:setup_foldlevel()

if config.org_startup_indented then
  vim.b.org_indent_mode = true
end
require('orgmode.org.indent').setup()

vim.b.org_bufnr = vim.api.nvim_get_current_buf()
vim.bo.modeline = false
vim.opt_local.fillchars:append('fold: ')
vim.opt_local.foldmethod = 'expr'
vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
if utils.has_version_10() then
  vim.opt_local.foldtext = ''
else
  vim.opt_local.foldtext = 'v:lua.require("orgmode.org.indent").foldtext()'
end
vim.opt_local.formatexpr = 'v:lua.require("orgmode.org.format")()'
vim.opt_local.omnifunc = 'v:lua.orgmode.omnifunc'
vim.opt_local.commentstring = '# %s'

_G.orgmode.omnifunc = function(findstart, base)
  return require('orgmode.org.autocompletion.omni').omnifunc(findstart, base)
end

local abbreviations = {
  [':today:'] = "require('orgmode.objects.date').today():to_wrapped_string(true)",
  [':now:'] = "require('orgmode.objects.date').now():to_wrapped_string(true)",
  [':itoday:'] = "require('orgmode.objects.date').today():to_wrapped_string(false)",
  [':inow:'] = "require('orgmode.objects.date').now():to_wrapped_string(false)",
}

for abbrev, cmd in pairs(abbreviations) do
  vim.cmd.inoreabbrev(('<silent><buffer> %s <C-R>=luaeval("%s")<CR>'):format(abbrev, cmd))
end
