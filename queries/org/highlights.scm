(timestamp "<") @OrgTSTimestampActive
(timestamp "[") @OrgTSTimestampInactive
(headline (stars) @stars (#eq? @stars "*")) @OrgTSHeadlineLevel1
(headline (stars) @stars (#eq? @stars "**")) @OrgTSHeadlineLevel2
(headline (stars) @stars (#eq? @stars "***")) @OrgTSHeadlineLevel3
(headline (stars) @stars (#eq? @stars "****")) @OrgTSHeadlineLevel4
(headline (stars) @stars (#eq? @stars "*****")) @OrgTSHeadlineLevel5
(headline (stars) @stars (#eq? @stars "******")) @OrgTSHeadlineLevel6
(headline (stars) @stars (#eq? @stars "*******")) @OrgTSHeadlineLevel7
(headline (stars) @stars (#eq? @stars "********")) @OrgTSHeadlineLevel8
(headline (item) @spell)
(list (listitem (paragraph) @spell))
(body (paragraph) @spell)
(bullet) @OrgTSBullet
(checkbox) @OrgTSCheckbox
(checkbox status: (_) @OrgTSCheckboxHalfChecked (#eq? @OrgTSCheckboxHalfChecked "-"))
(checkbox status: (_) @OrgTSCheckboxChecked (#any-of? @OrgTSCheckboxChecked "x" "X"))
(block "#+begin_" @OrgTSBlock "#+end_" @OrgTSBlock)
(block name: (name) @OrgTSBlock)
(block end_name: (name) @OrgTSBlock)
(block parameter: (str) @OrgTSBlock)
(dynamic_block name: (name) @OrgTSBlock)
(dynamic_block end_name: (name) @OrgTSBlock)
(dynamic_block parameter: (str) @OrgTSBlock)
(property_drawer) @OrgTSPropertyDrawer
(latex_env) @OrgTSLatex
(drawer) @OrgTSDrawer
(tag_list) @OrgTSTag
(plan) @OrgTSPlan
(comment) @OrgTSComment @spell
(directive) @OrgTSDirective
(ERROR) @LspDiagnosticsUnderlineError
