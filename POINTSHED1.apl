﻿    ∇ Z←F POINTSHED1 X;fd;Y[1]   ⍝Build a watershed for cell I,J ⍵, given D8 flow grid ⍺[2]   ⍝ORIGINAL VERSION - PRETTY SLOW![3]   ⍝B. Compton, 9 Dec 2014[4]   [5]   [6]   [7]    fd←(2*¯1+⍳8),8 2⍴0 1 1 1 1 0 1 ¯1 0 ¯1 ¯1 ¯1 ¯1 0 ¯1 1[8]    Z←(⍴F)⍴0[9]    Z[X[1];X[2]]←1         ⍝Outflow of watershed[10]  L1:Z←Z∨F DOWNFLOW Y←Z   ⍝   Grow watershed up[11]   FLUSH[12]   →(~Y≡Z)/L1             ⍝Until nothing else flows in    ∇