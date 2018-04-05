﻿    ∇ Z←N TIDE E;S[1]   ⍝Give tidal period & tidal depth for elevation and tide range ⍵ (and precision ⍺)[2]   ⍝Tidal period is number of hours/day innundation[3]   ⍝Tidal depth is maximum depth of innundation in meters[4]   [5]   ⍝*** THIS IS AN OLD TEST VERSION, USED FOR PLOTTING.  USE TIDES TO CREATE SETTINGS VARIABLES.[6]   ⍝B. Compton, 9 Dec 08[7]   [8]    ⍎(0=⎕NC'N')/'N←1000'   ⍝Number of points (=precision)[9]    S←E[2]×1○(○2)×(⍳N)÷N   ⍝Sine wave, 1 cycle, scaled to tidal range[10]   S←0⌈S-E[1]             ⍝water higher than land at point[11]  [12]   head←'time,depth'[13]   ((⍳N),[1.5]S) CMATOUT 'D:\CAPS\TIDES\WORKING\TIDES.TXT'   ⍝Write example for graphing[14]  [15]   Z←(24×(+/S>0)÷N),⌈/,S    ∇