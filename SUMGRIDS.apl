﻿    ∇ Z←W SUMGRIDS X;E;Q;C;H;G[1]   ⍝Merge grids 1⊃⍵ and 2⊃⍵ with 1st row, 1st col, rows, cols 1⊃⍺ and 2⊃⍺[2]   ⍝Return (window) (matrix)[3]   ⍝B. Compton, 15 Aug 2012 (from deprecated MERGEGRIDS)[4]   [5]   [6]   [7]    H G ← X[8]    E Q ← W[9]    E←E[1 2],E[1 2]+E[3 4]                         ⍝Four corners of E[10]   Q←Q[1 2],Q[1 2]+Q[3 4]                         ⍝and Q[11]  [12]   C←(Q[1 2]⌊E[1 2]),Q[3 4]⌈E[3 4]                ⍝window into combined grid[13]   H←(C[3 4]-C[1 2])↑(-(⍴H)+E[1 2]-C[1 2])↑H[14]   H←H+(C[3 4]-C[1 2])↑(-(⍴G)+Q[1 2]-C[1 2])↑G    ⍝merge two grids and update window[15]  [16]   C←C[1 2],C[3 4]-C[1 2]                         ⍝back to READBLOCK-style window[17]   Z←C H    ∇