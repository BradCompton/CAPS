﻿    ∇ Z←W MEAN X[1]   ⍝Give mean across matrices in ⍵, weighted by ⍺[2]   [3]    ⍎(0=⎕NC'W')/'W←1'[4]    →(1<≡X)/L1          ⍝If just a vector or matrix, give weighted mean of all values[5]    Z←(W←,W)/,MVREP X←,X[6]    Z←(+/Z)÷(⍴Z)-+/W/X∊MV[7]    →0[8]   L1:Z←W/MVREP¨,X[9]    Z←X REMV ⊃(+/Z)÷⍴Z  ⍝Else, give weighted mean across matrices    ∇