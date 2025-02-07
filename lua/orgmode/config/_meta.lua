---@meta
---@alias OrgAgendaSpan 'day' | 'week' | 'month' | 'year' | number

---@class OrgAgendaCustomCommandTypeInterface
---@field type? 'agenda' | 'tags' | 'tags_todo'
---@field org_agenda_overriding_header? string
---@field org_agenda_files? string[]
---@field org_agenda_tag_filter_preset? string
---@field org_agenda_category_filter_preset? string
---@field org_agenda_sorting_strategy? OrgAgendaSortingStrategy[]
---@field org_agenda_remove_tags? boolean

---@class OrgAgendaCustomCommandAgenda:OrgAgendaCustomCommandTypeInterface
---@field org_agenda_span? OrgAgendaSpan Default: 'week'
---@field org_agenda_start_day? string Modifier from today, example '+1d'
---@field org_agenda_start_on_weekday? number

---@class OrgAgendaCustomCommandTags:OrgAgendaCustomCommandTypeInterface
---@field match? string
---@field org_agenda_todo_ignore_scheduled? OrgAgendaTodoIgnoreScheduledTypes
---@field org_agenda_todo_ignore_deadlines? OrgAgendaTodoIgnoreDeadlinesTypes

---@alias OrgAgendaCustomCommandType (OrgAgendaCustomCommandAgenda | OrgAgendaCustomCommandTags)

---@class OrgAgendaCustomCommand
---@field description string Description in prompt
---@field types? OrgAgendaCustomCommandType[]

---@class OrgCustomExport
---@field label string
---@field action function(fun(cmd: string[], target: string, on_success: function, on_error: function))

---@class OrgCalendarSettings
---@field round_min_with_hours? boolean Should minutes be rounded to hour when changing hour. Default: true
---@field min_small_step? number Step size for changing the minutes while cursor is on the second digit. Default: value of `org_time_stamp_rounding_minutes` = 5
---@field min_big_step? number Step size for changing the minutes while cursor is on the first digit. Default: 15

---@class OrgNotificationsConfig
---@field enabled? boolean Enable notifications. Default: false
---@field cron_enabled? boolean Enable cron notifications. Default: true
---@field repeater_reminder_time? boolean | number | number[] Number of minutes before the repeater time to send the notifiaction. Default: false
---@field deadline_warning_reminder_time? boolean | number | number[] Number of minutes before the deadline wrning time to send the notifiaction. Default: 0
---@field reminder_time? boolean | number | number[] Number of minutes before the time to send the notifiaction. Default: 10
---@field deadline_reminder? boolean Enable notifiactions for DEADLINE dates. Default: true
---@field scheduled_reminder? boolean Enable notifiactions for DEADLINE dates. Default: true

---@class OrgMappingsGlobal
---@field org_agenda? string Mappings used to open agenda prompt. Default: '<prefix>a'
---@field org_capture? string Mappings used to open capture prompt. Default: '<prefix>c'

---@class OrgHyperlinksConfig
---@field sources OrgLinkType[]

---@class OrgMappingsAgenda
---@field org_agenda_later? string Default: 'f'
---@field org_agenda_earlier? string Default: 'b'
---@field org_agenda_goto_today? string Default: '.'
---@field org_agenda_day_view? string Default: 'vd'
---@field org_agenda_week_view? string Default: 'vw'
---@field org_agenda_month_view? string Default: 'vm'
---@field org_agenda_year_view? string Default: 'vy'
---@field org_agenda_quit? string Default: 'q'
---@field org_agenda_switch_to? string Default: '<CR>'
---@field org_agenda_goto? string Default: '<TAB>'
---@field org_agenda_goto_date? string Default: 'J'
---@field org_agenda_redo? string Default: 'r'
---@field org_agenda_todo? string Default: 't'
---@field org_agenda_clock_goto? string Default: '<prefix>xj'
---@field org_agenda_set_effort? string Default: '<prefix>xe'
---@field org_agenda_clock_in? string Default: 'I'
---@field org_agenda_clock_out? string Default: 'O'
---@field org_agenda_clock_cancel? string Default: 'X'
---@field org_agenda_clockreport_mode? string Default: 'R'
---@field org_agenda_priority? string Default: '<prefix>,'
---@field org_agenda_priority_up? string Default: '+'
---@field org_agenda_priority_down? string Default: '-'
---@field org_agenda_archive? string Default: '<prefix>$'
---@field org_agenda_toggle_archive_tag? string Default: '<prefix>A'
---@field org_agenda_set_tags? string Default: '<prefix>t'
---@field org_agenda_deadline? string Default: '<prefix>id'
---@field org_agenda_schedule? string Default: '<prefix>is'
---@field org_agenda_filter? string Default: '/'
---@field org_agenda_refile? string Default: '<prefix>r'
---@field org_agenda_add_note? string Default: '<prefix>na'
---@field org_agenda_show_help? string Default: 'g?'
---
---@class OrgMappingsCapture
---@field org_capture_finalize? string Default: '<C-c>'
---@field org_capture_refile? string Default: '<prefix>r'
---@field org_capture_kill? string Default: '<prefix>k'
---@field org_capture_show_help? string Default: 'g?'
---
---@class OrgMappingsNote
---@field org_note_finalize? string Default: '<C-c>'
---@field org_note_kill? string Default: '<prefix>k'
---
---@class OrgMappingsOrg
---@field org_refile? string Default: '<prefix>r'
---@field org_timestamp_up_day? string Default: '<S-UP>'
---@field org_timestamp_down_day? string Default: '<S-DOWN>'
---@field org_timestamp_up? string Default: '<C-a>'
---@field org_timestamp_down? string Default: '<C-x>'
---@field org_change_date? string Default: 'cid'
---@field org_priority? string Default: '<prefix>,'
---@field org_priority_up? string Default: 'ciR'
---@field org_priority_down? string Default: 'cir'
---@field org_todo? string Default: 'cit'
---@field org_todo_prev? string Default: 'ciT'
---@field org_toggle_checkbox? string Default: '<C-Space>'
---@field org_toggle_heading? string Default: '<prefix>*'
---@field org_open_at_point? string Default: '<prefix>o'
---@field org_edit_special? string Default: "<prefix>'"
---@field org_add_note? string Default: '<prefix>na'
---@field org_cycle? string Default: '<TAB>'
---@field org_global_cycle? string Default: '<S-TAB>'
---@field org_archive_subtree? string Default: '<prefix>$'
---@field org_set_tags_command? string Default: '<prefix>t'
---@field org_toggle_archive_tag? string Default: '<prefix>A'
---@field org_do_promote? string Default: '<<'
---@field org_do_demote? string Default: '>>'
---@field org_promote_subtree? string Default: '<s'
---@field org_demote_subtree? string Default: '>s'
---@field org_meta_return? string Add heading, item or row (context-dependent) Default: '<Leader><CR>'
---@field org_return? string Default: '<CR>'
---@field org_insert_heading_respect_content? string Add new heading after current heading block (same level) Default: '<prefix>ih'
---@field org_insert_todo_heading? string Add new todo heading right after current heading (same level) Default: '<prefix>iT'
---@field org_insert_todo_heading_respect_content? string Add new todo heading after current heading block (same level). Default: '<prefix>it'
---@field org_move_subtree_up? string Default: '<prefix>K'
---@field org_move_subtree_down? string Default: '<prefix>J'
---@field org_export? string Default: '<prefix>e'
---@field org_next_visible_heading? string Default: '}'
---@field org_previous_visible_heading? string Default: '{'
---@field org_forward_heading_same_level? string Default: ']]'
---@field org_backward_heading_same_level? string Default: '[['
---@field outline_up_heading? string Default: 'g{'
---@field org_deadline? string Default: '<prefix>id'
---@field org_schedule? string Default: '<prefix>is'
---@field org_time_stamp? string Default: '<prefix>i.'
---@field org_time_stamp_inactive? string Default: '<prefix>i!'
---@field org_toggle_timestamp_type? string Default: '<prefix>d!'
---@field org_insert_link? string Default: '<prefix>li'
---@field org_store_link? string Default: '<prefix>ls'
---@field org_clock_in? string Default: '<prefix>xi'
---@field org_clock_out? string Default: '<prefix>xo'
---@field org_clock_cancel? string Default: '<prefix>xq'
---@field org_clock_goto? string Default: '<prefix>xj'
---@field org_set_effort? string Default: '<prefix>xe'
---@field org_show_help? string Default: 'g?'
---@field org_babel_tangle? string Default: '<prefix>bt'
---@field org_attach? string Default: '<prefix><C-A>'

---@class OrgMappingsTextObjects
---@field inner_heading? string Default: 'ih'
---@field around_heading? string Default: 'ah'
---@field inner_subtree? string Default: 'ir'
---@field around_subtree? string Default: 'ar'
---@field inner_heading_from_root? string Default: 'Oh'
---@field around_heading_from_root? string Default: 'OH'
---@field inner_subtree_from_root? string Default: 'Or'
---@field around_subtree_from_root? string Default: 'OR'
---
---@class OrgMappingsEditSrc
---@field org_edit_src_abort? string Default: '<prefix>k'
---@field org_edit_src_save? string Default: '<prefix>w'
---@field org_edit_src_save_exit? string Default: "<prefix>'"
---@field org_edit_src_show_help? string Default: 'g?'
---
---@class OrgEmacsConfig
---@field executable_path? string path to emacs executable. Default: 'emacs'
---@field config_path? string | nil path to emacs config file. If nil, attempts to find the config automatically. Default: nil
---

---@class OrgUiConfig
---@field folds? { colored: boolean } Should folds be colored or use the default folding highlight. Default: { colored: true }
---@field menu? { handler: fun() | nil } Menu configuration
---@field input? { use_vim_ui: boolean } Input configuration

---@class OrgMappingsConfig
---@field disable_all? boolean Disable all mappings. Default: false
---@field org_return_uses_meta_return? boolean When true, `<CR>` will act as `<Leader><CR>` when applicable. Default: false
---@field prefix? string Default prefix for mappings. Default: '<Leader>o'
---@field global? OrgMappingsGlobal
---@field agenda? OrgMappingsAgenda
---@field capture? OrgMappingsCapture
---@field note? OrgMappingsNote
---@field edit_src? OrgMappingsEditSrc
---@field org? OrgMappingsOrg
---@field text_objects? OrgMappingsTextObjects

---@class OrgConfigOpts
---@field org_agenda_files? string | string[] Path(s) to org files. Can be a glob pattern (example: `~/org/**/*`). Default: {}
---@field org_default_notes_file? string Path to default file for captures. Default: ''
---@field org_todo_keywords? string[] List of todo/done states, separated by `|`. Default: { 'TODO', '|', 'DONE' }
---@field org_todo_repeat_to_state? string | nil An `org_todo_keywords` todo entry to use as a "starting" state for repeatable todos. Defaults to first todo state
---@field org_todo_keyword_faces? table<string, string> Custom faces (colors) for todo keywords. Default: {}
---@field org_deadline_warning_days? number Number of days during which deadline becomes visible in today's agenda. Default: 14
---@field org_agenda_min_height? number Minimum height of the agenda window. Default: 16
---@field org_agenda_span? OrgAgendaSpan Default time span for the agenda view. Default: 'week'
---@field org_agenda_start_on_weekday? number | false From which day in week (ISO weekday, 1 is Monday) to show the agenda. Applies only to `week` span. Default: 1
---@field org_agenda_start_day? string | nil Offset applied to the `org_agenda_start_on_weekday` in format `+1d`, `+2w`, etc. Default: nil
---@field calendar_week_start_day? 0 | 1 From which day to start the week in the Calendar. 0 is Sunday, 1 is Monday. Default: 1
---@field calendar? OrgCalendarSettings Calendar settings
---@field org_capture_templates? table<string, OrgCaptureTemplateOpts> Templates for capture. Default: { t = { description = 'Task', template = '* TODO %?\n  %u' } }
---@field org_startup_folded? 'overview' | 'content' | 'showeverything' |'inherit' How many levels of headings to show when opening a file. Default: 'overview'
---@field org_agenda_skip_scheduled_if_done? boolean If true, scheduled entries marked as done will not be shown in the agenda. Default: false
---@field org_agenda_skip_deadline_if_done? boolean If true, deadline entries marked as done will not be shown in the agenda. Default: false
---@field org_agenda_text_search_extra_files? ('agenda-archives')[] Additional files to earch from agenda search prompt. Default: {}
---@field org_agenda_custom_commands? table<string, OrgAgendaCustomCommand> Custom commands for the agenda view. Default: {}
---@field org_agenda_block_separator? string Separator for blocks in the agenda view. Default: '-'
---@field org_agenda_sorting_strategy? table<'agenda' | 'todo' | 'tags', OrgAgendaSortingStrategy[]> Sorting strategy for the agenda view. See docs for default value
---@field org_agenda_remove_tags? boolean If true, tags will be removed from the all agenda views. Default: false
---@field org_priority_highest? string | number Highest priority level. Default: 'A'
---@field org_priority_default? string | number Default priority level. Default: 'B'
---@field org_priority_lowest? string | number Lowest priority level. Default: 'C'
---@field org_priority_start_cycle_with_default? boolean If true, cycling priorities will start with the default priority. Default: true
---@field org_archive_location? string Location where to archive subtrees. `%s` indicates the file name from where archiving is done. Default: '%s_archive::'
---@field org_tags_column? number Padding for tags column. Negative indicates how many columns to pad from headline. Positive indicates specific column. Default: -80
---@field org_use_tag_inheritance? boolean If true, tags will be inherited from parent headlines. Default: true
---@field org_tags_exclude_from_inheritance? string[] List of tags that should be excluded from tag inheritance. Default: {}
---@field org_hide_leading_stars? boolean If true, leading stars on the headlines with level > 1 will be hidden. Default: false
---@field org_hide_emphasis_markers? boolean If true, emphasis markers will be hidden with conceal feature. Default: false
---@field org_ellipsis? string Ellipsis character to use when folding text. Default: '...'
---@field org_log_done? 'time' | 'note' How to log done tasks. `time` indicates adding CLOSED date. `note` prompts for closing note. Default: 'time'
---@field org_log_repeat? 'time' | 'note' | false How to log repeated tasks. `time` just logs the time of repeat. `note` prompts for closing note alongside the time. `false` disables. Default: 'time'
---@field org_log_into_drawer? string | nil Drawer name where to log notes. Default: nil
---@field org_highlight_latex_and_related? 'native' | 'entities' | nil What level of latex highlighting to use. This option is experimental. Default: nil
---@field org_custom_exports? table<string, OrgCustomExport> List of custom exports. Default: {}
---@field org_adapt_indentation? boolean Add spaces as indents to the content. Default: true
---@field org_startup_indented? boolean If true, apply virtual indents to the content. Default: false
---@field org_indent_mode_turns_off_org_adapt_indentation? boolean If true, turning on indent mode will turn off `org_adapt_indentation`. Default: true
---@field org_indent_mode_turns_on_hiding_stars? boolean If true, turning on indent mode will hide leading stars. Default: true
---@field org_time_stamp_rounding_minutes? number Rounding minutes for time stamps. Default: 5
---@field org_cycle_separator_lines? number Min number of spaces are needed at the end of headline to show empty line between folds. Default: 2
---@field org_blank_before_new_entry? { heading: boolean, plain_list_item: boolean } Should blank line be prepended. Default: { heading = true, plain_list_item = false }
---@field org_src_window_setup? string | fun() How to open "special edit" buffer window. Default: 'top 16new'
---@field org_edit_src_content_indentation? number Addditional ndentation number applied when editing a SRC block through special edit. Default: 0
---@field org_id_uuid_program? string External proram to generate UUIDs. Default: 'uuidgen'
---@field org_id_ts_format? string  Format of the id generated when `org_id_method = 'ts'`. Default: '%Y%m%d%H%M%S'
---@field org_id_method? 'uuid' | 'ts' | 'org' What method to use to generate ids via org.id module. Default: 'uuid'
---@field org_id_prefix? string | nil Prefix to apply to id when `org_id_method = 'org'`. Default: nil
---@field org_id_link_to_org_use_id? boolean If true, Storing a link to the headline will automatically generate ID for that headline. Default: false
---@field org_use_property_inheritance boolean | string | string[] If true, properties are inherited by sub-headlines; may also be a regex or list of property names. Default: false
---@field org_babel_default_header_args? table<string, string> Default header args for org-babel blocks: Default: { [':tangle'] = 'no', [':noweb'] = 'no' }
---@field org_resource_download_policy 'always' | 'prompt' | 'safe' | 'never' Policy for downloading files from the Internet. Default: 'prompt'
---@field org_safe_remote_resources string[] List of regex patterns for URIs considered always safe to download from. Default: {}
---@field org_attach_preferred_new_method 'id' | 'dir' | 'ask' | false If true, create attachments directory when necessary according to the given method. Default: 'id'
---@field org_attach_method 'mv' | 'cp' | 'ln' | 'lns' Default method of attacahing files. Default: 'cp'
---@field org_attach_visit_command string | fun(dir: string) Command or Lua function used to open a directory. Default: 'edit'
---@field org_attach_use_inheritance 'always' | 'selective' | 'never' Determines whether headlines inherit the attachments directory of their parents. Default: 'selective'
---@field org_attach_store_link_p 'original' | 'file' | 'attached' | false If true, attaching a file stores a link to it. Default: 'attached'
---@field org_attach_archive_delete 'always' | 'ask' | 'never' Determines whether to delete a headline's attachments when it is archived. Default: 'never'
---@field org_attach_id_to_path_function_list (string | fun(id: string): (string|nil))[] List of functions used to derive the attachments directory from an ID property.
---@field org_attach_sync_delete_empty_dir 'always' | 'ask' | 'never' Determines whether to delete empty directories when using `org.attach.sync()`. Default: 'ask'
---@field win_split_mode? 'horizontal' | 'vertical' | 'auto' | 'float' | string[] How to open agenda and capture windows. Default: 'horizontal'
---@field win_border? 'none' | 'single' | 'double' | 'rounded' | 'solid' | 'shadow' | string[] Border configuration for `win_split_mode = 'float'`. Default: 'single'
---@field notifications? OrgNotificationsConfig Notification settings
---@field mappings? OrgMappingsConfig Mappings configuration
---@field emacs_config? OrgEmacsConfig Emacs cnfiguration
---@field ui? OrgUiConfig UI configuration
---@field hyperlinks OrgHyperlinksConfig  Custom sources for hyperlinks
