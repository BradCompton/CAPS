﻿    ∇ Z←E SUBDIRS Q[1]   ⍝Give names of subdirectories of path ⍵, excluding Arc grids if ⍺[2]   ⍝B. Compton, 7 Mar 2011[3]   [4]   [5]    ⍎(0=⎕NC'E')/'E←1'[6]    Z←⍳0 ⋄ →(0∊⍴Q←FRDBL Q)/0[7]    Z←FRDBL¨↓0 ¯1↓RJUST('\'∊¨↓Z)⌿Z←⎕LIB Q[8]    →(~E)/L1                                            ⍝If ⍺, exclude arc grids[9]    Z←((TOLOWER Z)~⊂'info')~(FRDBL¨↓TOLOWER GRIDLIST Q)[10]  L1:Z←Z,¨'\'    ∇