﻿    ∇ Z←R RPATH F;I;J;X;C;D;E;Q;A;M;P[1]   ⍝Draw a random low-cost path from cell 1⊃⍵ to a true cell in matrix 2⊃⍵ following 8×R×C probability array ⍺[2]   ⍝Global:[3]   ⍝   momentum    strength and persistence of momentum[4]   ⍝Returns:[5]   ⍝   matrix corresponding to the window, with number of times for each cell was traversed[6]   ⍝   a list of x,ys traversed (if ~drawpaths≡0)[7]   ⍝B. Compton, 29 Oct 2012. First day of Hurricane Sandy. Windy, rainy...just heard a big tree come down.[8]   ⍝28 Nov 2012: instead of single end cell, end at any cell in target node and community[9]   [10]  [11]  [12]   I J ← 1⊃F[13]   E←2⊃F[14]   X←(1↓⍴R)⍴0[15]   X[I;J]←1[16]   C←1 2⍴I J[17]   D←8 2⍴¯1 ¯1 ¯1 0 ¯1 1 0 ¯1 0 1 1 ¯1 1 0 1 1        ⍝8 neighbors, in row-major order[18]   A←¯1                                               ⍝Set initial angle to momentum (no direction)[19]  ⍝qq←⍳0[20]  L1:→E[I;J]/L9                                       ⍝Until we've reached an end-cell,[21]  ⍝⎕←A ⋄ FLUSH[22]   P←R[;I;J][23]   →(0≡momentum)/L2                                   ⍝   if using momentum,[24]   Q←momentum[1] ANGLE2CELL A                         ⍝      convert angle & strength to probability vector[25]  ⍝   P←P÷+/P[26]    P←P÷+/P←(P≠0)×.5×P+Q                                   ⍝      mean of P and Q (but always 0 if P is 0)[27]  ⍝  P←P÷+/P←P×Q                                   ⍝      multiple P by Q[28]  ⍝  P←P÷+/P←(P≠0)×P⌈Q                                   ⍝      take max of P by momentum, but never go in directions where P = 0[29]   ⍝P←¯1↓+\P÷+/P←(P≠0)×P⌈Q                                   ⍝      take max of P by momentum, but never go in directions where P = 0[30]  L2:P←¯1↓+\P[31]  [32]  [33]  I J ← I J + D[M←1++/(1E¯6×?1E6)≥P;]              ⍝   pick new random cell[34]   X[I;J]←X[I;J]+1[35]   C←C⍪I J[36]   →(10000<1↑⍴C)/L98[37]  ⍝ ⍎((⌊T)=T←.001×1↑⍴C)/'(⍕1↑⍴C) ⋄ FLUSH'[38]  [39]   →(0≡momentum)/L1                                   ⍝   if using momentum,[40]  ⍝ A←(A×momentum[2])+(315 0 45 270 90 225 180 135[M])×1-momentum[2][41]    A←((momentum[2]×A≠¯1),1-momentum[2]×A≠¯1) CIRCLEMEAN A,315 0 45 270 90 225 180 135[M][42]  ⍝ A←CIRCLEMEAN 2↑((1+A=¯1)⍴315 0 45 270 90 225 180 135[M]),A[43]  [44]  ⍝qq←qq,A[45]   →L1                                                ⍝Repeat[46]  [47]  [48]  L98:⎕←'INFINITE LOOP!'[49]  [50]  L9:Z ← X C[51]  [52]  [53]  [54]  ⍝ T←0⌈block[6]-block[2 3]-1 ⋄ (T↓X) WRITEBLOCK  (⊂'D:\CAPS\WORKING\PATHS'),(1⌈block[2 3]-block[6]),((-T)+1+2⍴2×block[6]),0,2,1[55]      ∇