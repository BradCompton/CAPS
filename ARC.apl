﻿    ∇ S ARC P;Z[1]   ⍝Run Arc on arc.aml in path ⍵; run script ⍺ if supplied[2]   ⍝⍺ is delimited vector; trailing quit is added to ensure return[3]   ⍝Example: '&r makegrids' ARC pathR[4]   ⍝B. Compton, updated 21 Nov 2007[5]   ⍝16 Dec 2016: turn on echo to help with debugging[6]   [7]   [8]   [9]    BREAKCHECK[10]   →(0=⎕NC'S')/L1[11]   S←'/⋄/&' TEXTREPL S                ⍝Just in case CLUSTER took away an & we need for Arc[12]   ('&echo &brief',⎕TCNL,S,⎕TCNL,'del arc.aml',⎕TCNL,'q') NWRITE P,'arc.aml'[13]  L1:Z←1 ⎕CMD (1↑P),': & cd ',P,' & arc'[14]   BREAKCHECK    ∇