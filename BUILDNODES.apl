﻿    ∇ A BUILDNODES S;head;X;V;communities;C;I;Z;D;B;Q[1]   ⍝Build nodes for CAPS connectivity metric[2]   ⍝Finds the highest IEI for each community in tile (in case of ties, take point[3]   ⍝closest to center of tile), and write to nodes.txt.[4]   ⍝This is the first step. Next, run FINDPATHS, then CONNECTIVITY.[5]   ⍝Tile size is set in metrics.par[6]   ⍝Source:[7]   ⍝   land        Landcover grid[8]   ⍝   iei         Statewide/global iei[9]   ⍝Parameters:[10]  ⍝   communities Points to text file listing communities to treat separately (use synonyms.par to group them)[11]  ⍝   set tile size in metrics.par to control grid spacing[12]  ⍝Results:[13]  ⍝   nodes.txt   Nodes file[14]  ⍝B. Compton, 19 Feb 2013[15]  [16]  [17]  [18]  NO LONGER USED[19]  [20]  [21]   READPARS ME[22]   X←READ 1⊃1⊃A[23]   V←0 MVREP READ 2⊃1⊃A[24]   C←(LOOK¨C),C←1 0 TABLE pathI,communities   ⍝Read focal community table[25]   D←(⍴X)↑DIST ⌈/⍴X[26]   D←⊃(+/D (⌽D) (⊖D) (⌽⊖D))÷4                 ⍝Distance to center of tile (works for even-sized tiles)[27]   Z←((1↑⍴C),3)⍴0[28]   I←0[29]  L1:→((1↑⍴C)<I←I+1)/L2                       ⍝For each community/system,[30]   →(~∨/B←,X∊⊃C[I;1])/L1                      ⍝   Find cells in community[31]   B←B^(,V)=Q←⌈/B/,V                          ⍝   Want highest iei in community[32]   →(Q=0)/L1                                  ⍝   but not if it's zero[33]   B←B\<\(B/,D)=⌊/B/,D                        ⍝   and closest to center (upper-left wins when ties)[34]   Z[I;]←(INDICES (⍴X)⍴B),Q                   ⍝   save cell i, j, iei[35]   →L1[36]  [37]  L2:I←(1E5×⍳1↑⍴C)+block[5]+(block[4]-1)×block[7] ⍝id is community + block # (cccbbbbb)[38]   Z←I,Z[;1 2],('n',¨⍕¨I),Z[;3],1,[1.5]⍳1↑⍴C[39]   Z←(Z[;5]≠0)⌿Z                              ⍝No nodes if iei = 0[40]   Z[;2 3]←↑1 FINDPOINT¨↓Z[;2 3]              ⍝Convert cells to points[41]   Z LOCKWRITE pathQ,'tables\nodes.txt'[42]   →0[43]  [44]  [45]  [46]  what:auxiliary[47]  type:standard[48]  init:head←1↓⎕TCHT MTOV MATRIFY 'id centroid-x centroid-y name importance include community' ⋄ (0 0⍴'') TMATOUT pathQ,'tables\nodes.txt'[49]  info:('land' 'iei') ('') ('') (0) 'include'      ⍝Source grid, settings table, result grid, buffer size, and include grid    ∇