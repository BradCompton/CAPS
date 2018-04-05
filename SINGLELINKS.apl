﻿    ∇ A SINGLELINKS S;C;B;N;U;D;V;I;head;Q;W;R;K;M;P;Z;units;bandwidth;T;inflate[1]   ⍝Do first part of CAPS Critical Linkages II analysis in graphland: each unit singly[2]   ⍝B. Compton, 15 Jan 2013 (from FINDLINKS)[3]   [4]   [5]   [6]    READPARS ME[7]   [8]    N←0 1 TABLE pathQ,'tables\nodes.txt'           ⍝List of all nodes[9]    T←0 1 TABLE pathQ,'tables\nodevalues.txt'      ⍝and get IEI-weighted size of each node[10]   N[;5]←T[T[;4]⍳N[;1];5]                         ⍝which we'll use for node importance[11]   U←0 1 TABLE pathQ,'tables\liveunits.txt'       ⍝List of units we're using[12]   U←((⍳1↑⍴U)∊(⊃⊃S)+¯1+⍳2⊃⊃S)⌿U                   ⍝Units that we're doing in this thread[13]   W←MATIN pathQ,'tables\unitindex.txt'           ⍝Unit-internode index[14]   U←(U[;1]∊W[;1])⌿U                              ⍝We can't say anything about units not on paths, so drop them--they'll get nodata[15]  [16]   C←D←5 ROUND MATIN pathQ,'tables\distance',(⊃KNAMES bandwidth←bandwidth×1000),'.txt'          ⍝Read distance matrix[17]   V←N[;1 5] PC FLOYD D                           ⍝Fill out probability matrix and calculate P(C) for unmodified landscape[18]  [19]   Z←0 2⍴0[20]   I←0[21]  L1:→((1↑⍴U)<I←I+1)/L9                           ⍝For each unit,[22]   BREAKCHECK[23]   ⍎((I÷1000)=⌊I÷1000)/'⎕←⎕TCNL,(⍕I),'' of '',⍕1↑⍴U ⋄ dot←0'  ⍝      chatter every 1000 iterations[24]   DOT[25]   Q←(W[;1]∊U[I;1])⌿W[;2 3]                       ⍝   internodes affected[26]   →(0∊⍴Q)/L1                                     ⍝   If no paths affected on these units, move on[27]   DOT[28]   Q←Q[⍋Q;][29]   Q←(∨/Q≠0⍪¯1 0↓Q)⌿Q                             ⍝   unique internodes[30]   R←C                                            ⍝   original distance/probability matrix[31]   K←0[32]  L6:→((1↑⍴Q)<K←K+1)/L7                           ⍝   For each internode,[33]   M←MATIN pathQ,'tables\',(⍕Q[K;1]),'-',(⍕Q[K;2]),'edges.txt' ⍝      read edges file[34]   →(~units≡'passages')/L10                       ⍝      If units are passages,[35]   B←M[;1]≠0,¯1↓M[;1][36]   R[N[;1]⍳Q[K;1];N[;1]⍳Q[K;2]]←5 ROUND MEAN bandwidth GAUSS (B/M[;3])-B pSUM M[;4]×M[;2]=U[I;1]   ⍝         shorten distance by additional passage (round as in LINKTABLES)[37]   →L6                                            ⍝      Else, units are development,[38]  L10:R[N[;1]⍳Q[K;1];N[;1]⍳Q[K;2]]←5 ROUND MEAN bandwidth GAUSS (M[;1]≠0,¯1↓M[;1])/M[;3]×~M[;2]=U[I;1]  ⍝         pay the piper: (+/not dropped)÷⍴all[39]   →L6[40]  [41]  L7:→(R≡C)/L1                                    ⍝   If we've actually changed something,[42]   Q←-inflate×(÷V)×V-N[;1 5] PC FLOYD R           ⍝      normalized delta P(C) × inflate for these nodes[43]   Z←Z⍪Q,⊂U[I;1]                                  ⍝      delta and list of units[44]   →L1[45]  [46]  L9:Z LOCKWRITE pathQ,'tables\singlelinks',(⊃KNAMES bandwidth),'.txt'[47]   ⎕←''[48]   →0[49]  [50]  [51]  what:auxiliary[52]  type:table[53]  init:head←1↓⎕TCHT MTOV MATRIFY 'delta units' ⋄ (0 0⍴'') TMATOUT pathQ,'tables\singlelinks',(⊃KNAMES bandwidth×1000),'.txt'[54]  info:('') ('') ('') (0)[55]  check:CHECKVAR 'targets inflate bandwidth units'    ∇