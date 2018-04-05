﻿    ∇ DRAWLINKS H;N;D;I;pathT;pathR;head;Z;Q;T[1]   ⍝Draw internode links for bandwidths ⍵ (in m) as part of CL II[2]   ⍝Source:[3]   ⍝   tables\nodes.txt            Table of nodes[4]   ⍝   results\nodes\distance.txt  Distance matrix[5]   ⍝Results, in results\nodes\:[6]   ⍝   links.txt                   Table of id, node1, node2, distance, and pairs of direct,[7]   ⍝                               stepping stone P(connect) for each bandwidth[8]   ⍝   linklines.txt               Generate file for drawlines.aml[9]   ⍝In GIS, join linklines with links.txt on ID[10]      ⍝B. Compton, 7-8 Feb 2013 (Feb 8: Monster nor'easter on its way!)[11]      ⍝11 Feb 2013: new path scheme (we got about 20" with lots of drifting)[12]  [13]  [14]  OBSOLETE.  USE NODEIMPORTANCE INSTEAD.[15]  [16]  [17]   SETPATHS[18]   N←0 1 TABLE pathQ,'tables\nodes.txt'       ⍝List of all nodes[19]   D←MATIN pathQ,'tables\distance.txt'        ⍝Read distance matrix[20]  [21]   Z←(,⍉(⍴D)⍴N[;1]),(,(⍴D)⍴N[;1]),[1.5],D     ⍝From-node, to-node, distance,[22]   Z←(Z[;2]+Z[;1]×1000),Z                     ⍝and first colum is id (fffttt)[23]   Z←((⍴Z)+0,2×⍴H←,H)↑Z[24]  [25]   I←0[26]  L1:→((⍴H)<I←I+1)/L2                         ⍝For each bandwidth,[27]   Z[;4+¯1+I×2]←,H[I] GAUSS D                 ⍝   calculate direct P(connect)[28]   Z[;4+I×2]←,FLOYD H[I] GAUSS D             ⍝   and P(connect) using stepping stones[29]   →L1[30]  [31]  L2:T←Z[1;][32]   Z←(≠/Z[;2 3])⌿Z                            ⍝Drop all self links[33]   Z←T⍪((1↓⍴Z)↑4↑T)⍪Z                         ⍝but keep 2 short links 1→1 to trick ArcView into scaling 0 to 1[34]   Z[;4]←Z[;4]×Z[;4]≠1E6                      ⍝Zero out all distance of 1E6[35]   Z[;4↓⍳1↓⍴Z]←5 ROUND 0 4↓Z                  ⍝round all probabilities a bit[36]   Z←(∨/0≠0 4↓Z)⌿Z                            ⍝and drop all rows with no connections[37]   head←1↓⎕TCHT MTOV (MATRIFY 'id node1 node2 distance') OVER MIX ,⍉'ds'∘.,⍕¨H[38]   Z TMATOUT pathQ,'results\links.txt'[39]  [40]   Q←((2×1↑⍴Z),3)⍴(Z[;1],N[N[;1]⍳Z[;2];2 3]),(Z[;1],N[N[;1]⍳Z[;3];2 3])[41]   Q[2 4;3]←Q[2 4;3]+1                        ⍝2 short links so ArcView scales 0 to 1[42]   (pathQ,'results\linklines.txt') GENLINES Q[43]  [44]  [45]  ⎕←'Now in Arc, w ',pathQ,'results\ and &r drawlines linklines, then join coverage linklines with ',pathQ,'results\links.txt.'    ∇