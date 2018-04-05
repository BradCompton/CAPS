﻿    ∇ Z←P GRIDNAMENS N;G;head;K;T;Q;tablepath;S;Y;O;substmosaics[1]   ⍝Return name of grid ⍵ WITHOUT SUBSTITUTING MOSAICS from inputs.par; prepend path if 1⊃⍺; use replacement file 2⊃⍺.par (default = inputs.par)[2]   ⍝Simply return ⍵ if ⍺[1]=¯1[3]   ⍝Give mosaic out-of-date error if ⍺[1]=¯2[4]   ⍝Replace #'s with timestep (##, ###, and #### indicate number of digits; # indicates no zero padding)[5]   ⍝Replace % with year (same deal as #'s), and [scenario] with scenario[6]   ⍝Can supply alternate grid names in inputs.par for time step 0, ≥1[7]   ⍝B. Compton, 25 Feb 2009[8]   [9]   [10]  [11]   ⍎(0=⎕NC'P')/'P←0'[12]   substmosaics←0[13]   Z←P GRIDNAME N    ∇