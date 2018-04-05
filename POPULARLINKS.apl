﻿    ∇ POPULARLINKS P;T;C;V;bandwidth;D;N;E;Z;I;Q;head[1]   ⍝Test version of W2W regional connectivity--find most popular paths between ⍵ random pairs of nodes[2]   ⍝B. Compton, 21-24 Jul 2015[3]   [4]   [5]   [6]    INIT[7]    bandwidth←10[8]    [9]    N←0 1 TABLE pathQ,'tables\nodes.txt'           ⍝List of all nodes[10]   T←0 1 TABLE pathQ,'tables\nodevalues.txt'      ⍝and get IEI-weighted size of each node[11]   N[;5]←T[T[;4]⍳N[;1];5]                         ⍝which we'll use for node importance[12]   D←5 ROUND MATIN pathQ,'tables\distance',(⊃KNAMES bandwidth←bandwidth×1000),'.txt'          ⍝Read distance matrix[13]  [14]   V E ← FLOYD_SP0 D                          ⍝Build distance and next matrices[15]  [16]   ⎕←'Finding paths between ',(⍕P),' pairs of nodes...' ⋄ FLUSH[17]   [18]   Z←(⍴D)⍴0[19]   I←0[20]  L1:→(P<I←I+1)/L2                            ⍝For each random pair of nodes,[21]   Q←E FLOYD_SP 2?1↑⍴D                        ⍝   Find shortest path[22]   Q←(¯1↓Q),[1.5]1↓Q                          ⍝   Path in terms of pairs of nodes[23]   Z←Z+((⍴Z)⍴0) SCATR Q 1                     ⍝   Increment paths used[24]   →L1[25]  [26]  L2:Z←(INDICES Z),(,Z≠0)/,Z                  ⍝Pairs of indices and path counts[27]   Z[;1 2]←N[Z[;1 2];1]                       ⍝Replace indices with node ids[28]   Z←(⍳1↑⍴Z),Z[29]   [30]   Q←((2×1↑⍴Z),3)⍴(Z[;1],N[N[;1]⍳Z[;2];2 3]),(Z[;1],N[N[;1]⍳Z[;3];2 3])[31]  [32]   (pathQ,'results\paths.txt') GENLINES Q[33]   head←1↓⎕TCHT MTOV MATRIFY 'row node1 node2 count'[34]   Z TMATOUT T←pathQ,'results\pathcount.txt'[35]   ⎕←'Path counts written to ',T[36]   ⎕←'Now in Arc, w ',pathQ,'results\ and &r drawlines paths, then join coverage paths with ',pathQ,'results\pathcount.txt.'    ∇