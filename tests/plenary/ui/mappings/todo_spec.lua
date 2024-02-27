local helpers = require('tests.plenary.helpers')
local Date = require('orgmode.objects.date')
local config = require('orgmode.config')

describe('Todo mappings', function()
  after_each(function()
    vim.cmd([[silent! %bw!]])
  end)

  it('should change todo state of a headline forward (org_todo)', function()
    helpers.create_agenda_file({
      '#TITLE: Test',
      '',
      '* TODO Test orgmode',
      '  DEADLINE: <2021-07-21 Wed 22:02>',
    })
    assert.are.same({
      '* TODO Test orgmode',
      '  DEADLINE: <2021-07-21 Wed 22:02>',
    }, vim.api.nvim_buf_get_lines(0, 2, 4, false))
    vim.fn.cursor(3, 1)

    -- Changing to DONE and adding closed date
    vim.cmd([[norm cit]])
    assert.are.same({
      '* DONE Test orgmode',
      '  DEADLINE: <2021-07-21 Wed 22:02> CLOSED: [' .. Date.now():to_string() .. ']',
    }, vim.api.nvim_buf_get_lines(0, 2, 4, false))

    -- Removing todo keyword and removing closed date
    vim.cmd([[norm cit]])
    assert.are.same({
      '* Test orgmode',
      '  DEADLINE: <2021-07-21 Wed 22:02>',
    }, vim.api.nvim_buf_get_lines(0, 2, 4, false))

    -- Setting TODO keyword, initial state
    vim.cmd([[norm cit]])
    assert.are.same({
      '* TODO Test orgmode',
      '  DEADLINE: <2021-07-21 Wed 22:02>',
    }, vim.api.nvim_buf_get_lines(0, 2, 4, false))
  end)

  it('should change todo state of repeatable task and add last repeat property and state change (org_todo)', function()
    helpers.create_agenda_file({
      '#TITLE: Test',
      '',
      '* TODO Test orgmode',
      '  DEADLINE: <2021-09-07 Tue 12:00 +1w>',
      '',
      '* TODO Another task',
    })

    assert.are.same({
      '* TODO Test orgmode',
      '  DEADLINE: <2021-09-07 Tue 12:00 +1w>',
      '',
      '* TODO Another task',
    }, vim.api.nvim_buf_get_lines(0, 2, 6, false))
    vim.fn.cursor(3, 1)
    vim.cmd([[norm cit]])
    vim.wait(50)
    assert.are.same({
      '* TODO Test orgmode',
      '  DEADLINE: <2021-09-14 Tue 12:00 +1w>',
      '  :PROPERTIES:',
      '  :LAST_REPEAT: [' .. Date.now():to_string() .. ']',
      '  :END:',
      '  - State "DONE" from "TODO" [' .. Date.now():to_string() .. ']',
      '',
      '* TODO Another task',
    }, vim.api.nvim_buf_get_lines(0, 2, 10, false))
  end)
  it('should add last repeat property and state change to drawer (org_log_into_drawer)', function()
    config:extend({
      org_log_into_drawer = 'LOGBOOK',
    })

    helpers.create_agenda_file({
      '#TITLE: Test',
      '',
      '* TODO Test orgmode',
      '  DEADLINE: <2021-09-07 Tue 12:00 +1w>',
      '',
      '* TODO Another task',
    })

    assert.are.same({
      '* TODO Test orgmode',
      '  DEADLINE: <2021-09-07 Tue 12:00 +1w>',
      '',
      '* TODO Another task',
    }, vim.api.nvim_buf_get_lines(0, 2, 6, false))
    vim.fn.cursor(3, 1)
    vim.cmd([[norm cit]])
    vim.wait(50)
    assert.are.same({
      '* TODO Test orgmode',
      '  DEADLINE: <2021-09-14 Tue 12:00 +1w>',
      '  :PROPERTIES:',
      '  :LAST_REPEAT: [' .. Date.now():to_string() .. ']',
      '  :END:',
      '  :LOGBOOK:',
      '  - State "DONE" from "TODO" [' .. Date.now():to_string() .. ']',
      '  :END:',
      '',
      '* TODO Another task',
    }, vim.api.nvim_buf_get_lines(0, 2, 12, false))

    vim.fn.cursor(3, 1)
    vim.cmd([[norm cit]])
    vim.wait(200)
    assert.are.same({
      '* TODO Test orgmode',
      '  DEADLINE: <2021-09-21 Tue 12:00 +1w>',
      '  :PROPERTIES:',
      '  :LAST_REPEAT: [' .. Date.now():to_string() .. ']',
      '  :END:',
      '  :LOGBOOK:',
      '  - State "DONE" from "TODO" [' .. Date.now():to_string() .. ']',
      '  - State "DONE" from "TODO" [' .. Date.now():to_string() .. ']',
      '  :END:',
      '',
      '* TODO Another task',
    }, vim.api.nvim_buf_get_lines(0, 2, 13, false))
  end)
  it('should change todo state of a headline backward (org_todo_prev)', function()
    helpers.create_agenda_file({
      '#TITLE: Test',
      '',
      '* TODO Test orgmode',
      '  DEADLINE: <2021-07-21 Wed 22:02>',
    })

    assert.are.same({
      '* TODO Test orgmode',
      '  DEADLINE: <2021-07-21 Wed 22:02>',
    }, vim.api.nvim_buf_get_lines(0, 2, 4, false))
    vim.fn.cursor(3, 1)

    -- Removing todo keyword
    vim.cmd([[norm ciT]])
    assert.are.same({
      '* Test orgmode',
      '  DEADLINE: <2021-07-21 Wed 22:02>',
    }, vim.api.nvim_buf_get_lines(0, 2, 4, false))

    -- Changing to DONE and adding closed date
    vim.cmd([[norm ciT]])
    assert.are.same({
      '* DONE Test orgmode',
      '  DEADLINE: <2021-07-21 Wed 22:02> CLOSED: [' .. Date.now():to_string() .. ']',
    }, vim.api.nvim_buf_get_lines(0, 2, 4, false))

    -- Setting TODO keyword, initial state
    vim.cmd([[norm ciT]])
    assert.are.same({
      '* TODO Test orgmode',
      '  DEADLINE: <2021-07-21 Wed 22:02>',
    }, vim.api.nvim_buf_get_lines(0, 2, 4, false))
  end)

  it('Only modifies the actually todo keyword even when a match exists in the text', function()
    helpers.create_agenda_file({
      '* TODO test TODO',
    })
    vim.fn.cursor(1, 1)
    vim.cmd('norm ciT')
    assert.are.same('* test TODO', vim.fn.getline(1))
  end)

  it('Should properly add closed date when plan date is not of specific type', function()
    helpers.create_agenda_file({
      '#TITLE: Test',
      '',
      '* TODO Test orgmode',
      '  <2021-07-21 Wed 22:02>',
    })
    vim.fn.cursor({ 3, 1 })
    vim.cmd([[norm cit]])
    assert.are.same({
      '* DONE Test orgmode',
      '  CLOSED: [' .. Date.now():to_string() .. ']',
      '  <2021-07-21 Wed 22:02>',
    }, vim.api.nvim_buf_get_lines(0, 2, 5, false))
  end)
  it('Should reset state to the one defined in the REPEAT_TO_STATE property', function()
    config:extend({
      org_todo_keywords = { 'TODO(t)', 'PHONECALL(p)', 'WAITING(w)', '|', 'DONE(d)' },
      org_log_into_drawer = 'LOGBOOK',
    })
    helpers.load_file_content({
      '#+title: TEST',
      '',
      '* PHONECALL Call dad',
      '  SCHEDULED: <2021-09-07 Tue 12:00 +1d>',
      '  :PROPERTIES:',
      '  :REPEAT_TO_STATE: PHONECALL',
      '  :END:',
    })

    assert.are.same({
      '* PHONECALL Call dad',
      '  SCHEDULED: <2021-09-07 Tue 12:00 +1d>',
      '  :PROPERTIES:',
      '  :REPEAT_TO_STATE: PHONECALL',
      '  :END:',
    }, vim.api.nvim_buf_get_lines(0, 2, 7, false))
    vim.fn.cursor(3, 3)
    vim.cmd([[norm citd]])
    vim.wait(50)
    assert.are.same({
      '* PHONECALL Call dad',
      '  SCHEDULED: <2021-09-08 Wed 12:00 +1d>',
      '  :PROPERTIES:',
      '  :REPEAT_TO_STATE: PHONECALL',
      '  :LAST_REPEAT: [' .. Date.now():to_string() .. ']',
      '  :END:',
      '  :LOGBOOK:',
      '  - State "DONE" from "PHONECALL" [' .. Date.now():to_string() .. ']',
      '  :END:',
    }, vim.api.nvim_buf_get_lines(0, 2, 11, false))
  end)
end)
