﻿    ∇ ⍙N⍙ LINETIME ⍙X⍙;⍙A⍙;⍙I⍙[1]   ⍝Run line ⍵ ⍺ times (default = figure it out) and tell how long it takes per line[2]   ⍝B. Compton, 18 Feb 2014[3]   [4]   [5]   [6]    ⍎(0=⎕NC'⍙N⍙')/'⍙N⍙←0'[7]    :if ⍙N⍙=0                            ⍝If ⍺=0, figure out how many reps to run[8]       ⍙A⍙←⎕AI[2][9]       ⍎⍙X⍙[10]      ⍙N⍙←1E4⌊⌈5÷(1E¯5⌈⎕AI[2]-⍙A⍙)[11]   :end[12]   ⍙I⍙←0[13]   ⍙A⍙←⎕AI[2][14]  L1:→(⍙N⍙<⍙I⍙←⍙I⍙+1)/L2[15]     ⍎⍙X⍙[16]   →L1[17]  [18]  L2:⎕←'Time taken per line = ',(⍕1000×(⎕AI[2]-⍙A⍙)÷⍙N⍙),' milliseconds.'    ∇