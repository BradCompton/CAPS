﻿    ∇ V CHECKCOVER Q[1]   ⍝Make sure covertypes in table ⍵ exist; create table from single cover type if ⍺[2]   [3]    ⍎(0=⎕NC'V')/'V←0'[4]    :if V[5]       V←1 2⍴1 Q[6]       Q←'V'[7]    :end[8]    →(0=⎕NC Q)/0[9]    Q←1 LOOKUP ⍎Q    ∇