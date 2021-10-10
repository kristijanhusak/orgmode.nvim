lua require('orgmode.colors.highlights').define_agenda_colors()
syn match OrgAgendaDay /^\w\+\s\+\d\+\s\w\+\s\d\d\d\d$/
syn match OrgAgendaTags /:[^ ]*:$/
hi OrgBold gui=bold cterm=bold
hi OrgUnderline gui=underline cterm=underline
hi default link OrgAgendaDay Statement
hi default link OrgAgendaTags OrgBold
