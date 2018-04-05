﻿    ∇ Z←P SAMPLEGRID G;X;I;J;D[1]   ⍝Sample points ⍺ from path and grid(s) ⍵ and return matrix of points and values[2]   ⍝If ⍺ is a scalar or 1 element vector, sample ⍺ random points from the grids[3]   ⍝1st element of ⍵ is path, subsequent ones are grid names (with optional relative paths)[4]   ⍝Works pretty much the same as Arc/Grid's SAMPLE[5]   ⍝Note: sets and clears the access window...might not want that[6]   ⍝B. Compton, 19 Feb 2009[7]   [8]    G←MATRIFY G[9]    GRIDINIT ''[10]   SETWINDOW (FRDBL G[1;]),G[2;][11]  [12]   →(1≠⍴,P)/L1                            ⍝If ⍺ is a single number,[13]   D←WINDOW[14]   D←D[3 4],D[3 4]+D[1 2]×D[5][15]   X←D[1]+(UNIFORM P)×(D[3]-D[1])[16]   P←X,[1.5]D[2]+(UNIFORM P)×(D[4]-D[2])  ⍝   Pick ⍺ random points[17]  [18]  L1:Z←((1↑⍴P),1+1↑⍴G)↑P[19]   I←0[20]  L2:→((¯1+1↑⍴G)<I←I+1)/L4                ⍝For each grid, (do this gridwise to keep each grid in cache)[21]  ⍝ ⎕←⎕TCNL,G[I+1;][22]   J←0[23]  L3:→((1↑⍴Z)<J←J+1)/L2                   ⍝   For each point,[24]   ⍞←((J÷1000)=⌊J÷1000)/(⍕J),' ' ⋄ FLUSH[25]   Z[J;I+2]←READBLOCK (⊂(FRDBL G[1;]),G[I+1;]),(FINDCELL Z[J;1 2]),1 1[26]   →L3[27]  L4:⍝CLEANUP    ∇