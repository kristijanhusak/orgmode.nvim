return {
  agenda = {
    org_agenda_later = { 'agenda.advance_span', 1 },
    org_agenda_earlier = { 'agenda.advance_span', -1 },
    org_agenda_goto_today = { 'agenda.reset' },
    org_agenda_day_view = { 'agenda.change_span', 'day' },
    org_agenda_week_view = { 'agenda.change_span', 'week' },
    org_agenda_month_view = { 'agenda.change_span', 'month' },
    org_agenda_year_view = { 'agenda.change_span', 'year' },
    org_agenda_quit = { 'agenda.quit' },
    org_agenda_switch_to = { 'agenda.switch_to_item' },
    org_agenda_goto = { 'agenda.goto_item' },
    org_agenda_goto_date = { 'agenda.goto_date' },
    org_agenda_redo = { 'agenda.redo' },
    org_agenda_todo = { 'agenda.change_todo_state' },
    org_agenda_clock_in = { 'agenda.clock_in' },
    org_agenda_clock_out = { 'agenda.clock_out' },
    org_agenda_clock_cancel = { 'agenda.clock_cancel' },
    org_agenda_set_effort = { 'agenda.set_effort' },
    org_agenda_clock_goto = { 'clock.org_clock_goto' },
    org_agenda_clockreport_mode = { 'agenda.toggle_clock_report' },
    org_agenda_priority = { 'agenda.set_priority' },
    org_agenda_priority_up = { 'agenda.priority_up' },
    org_agenda_priority_down = { 'agenda.priority_down' },
    org_agenda_toggle_archive_tag = { 'agenda.toggle_archive_tag' },
    org_agenda_set_tags = { 'agenda.set_tags' },
    org_agenda_deadline = { 'agenda.set_deadline' },
    org_agenda_schedule = { 'agenda.set_schedule' },
    org_agenda_filter = { 'agenda.filter' },
    org_agenda_show_help = { 'org_mappings.show_help' },
  },
  capture = {
    org_capture_finalize = { 'capture.refile' },
    org_capture_refile = { 'capture.refile_to_destination' },
    org_capture_kill = { 'capture.kill' },
    org_capture_show_help = { 'org_mappings.show_help' },
  },
  org = {
    org_refile = { 'capture.refile_headline_to_destination' },
    org_timestamp_up_day = { 'org_mappings.timestamp_up_day' },
    org_timestamp_down_day = { 'org_mappings.timestamp_down_day' },
    org_timestamp_up = { 'org_mappings.timestamp_up' },
    org_timestamp_down = { 'org_mappings.timestamp_down' },
    org_change_date = { 'org_mappings.change_date' },
    org_todo = { 'org_mappings.todo_next_state' },
    org_priority = { 'org_mappings.set_priority' },
    org_priority_up = { 'org_mappings.priority_up' },
    org_priority_down = { 'org_mappings.priority_down' },
    org_todo_prev = { 'org_mappings.todo_prev_state' },
    org_toggle_checkbox = { 'org_mappings.toggle_checkbox' },
    org_toggle_heading = { 'org_mappings.toggle_heading' },
    org_open_at_point = { 'org_mappings.open_at_point' },
    org_edit_special = { 'org_mappings.edit_special' },
    org_cycle = { 'org_mappings.cycle' },
    org_global_cycle = { 'org_mappings.global_cycle' },
    org_archive_subtree = { 'org_mappings.archive' },
    org_set_tags_command = { 'org_mappings.set_tags' },
    org_toggle_archive_tag = { 'org_mappings.toggle_archive_tag' },
    org_do_promote = { 'org_mappings.do_promote' },
    org_do_demote = { 'org_mappings.do_demote' },
    org_promote_subtree = { 'org_mappings.do_promote', true },
    org_demote_subtree = { 'org_mappings.do_demote', true },
    org_meta_return = { 'org_mappings.handle_return' },
    org_insert_heading_respect_content = { 'org_mappings.insert_heading_respect_content' },
    org_insert_todo_heading = { 'org_mappings.insert_todo_heading' },
    org_insert_todo_heading_respect_content = { 'org_mappings.insert_todo_heading_respect_content' },
    org_move_subtree_up = { 'org_mappings.move_subtree_up' },
    org_move_subtree_down = { 'org_mappings.move_subtree_down' },
    org_export = { 'org_mappings.export' },
    org_next_visible_heading = {
      n = { 'org_mappings.next_visible_heading' },
      x = { 'org_mappings.next_visible_heading' },
    },
    org_previous_visible_heading = {
      n = { 'org_mappings.previous_visible_heading' },
      x = { 'org_mappings.previous_visible_heading' },
    },
    org_forward_heading_same_level = { 'org_mappings.forward_heading_same_level' },
    org_backward_heading_same_level = { 'org_mappings.backward_heading_same_level' },
    outline_up_heading = { 'org_mappings.outline_up_heading' },
    org_deadline = { 'org_mappings.org_deadline' },
    org_schedule = { 'org_mappings.org_schedule' },
    org_time_stamp = { 'org_mappings.org_time_stamp' },
    org_time_stamp_inactive = { 'org_mappings.org_time_stamp', true },
    org_clock_in = { 'clock.org_clock_in' },
    org_clock_out = { 'clock.org_clock_out' },
    org_clock_cancel = { 'clock.org_clock_cancel' },
    org_clock_goto = { 'clock.org_clock_goto' },
    org_set_effort = { 'clock.org_set_effort' },
    org_show_help = { 'org_mappings.show_help' },
  },
  text_objects = {
    inner_heading = 'inner_heading',
    around_heading = 'around_heading',
    inner_subtree = 'inner_subtree',
    around_subtree = 'around_subtree',
    inner_heading_from_root = 'inner_heading_from_root',
    around_heading_from_root = 'around_heading_from_root',
    inner_subtree_from_root = 'inner_subtree_from_root',
    around_subtree_from_root = 'around_subtree_from_root',
  },
}
