﻿    ∇ A MOVEPOOLS S;buffer;X;C;V;D;R;T;Q;B;reach;I;P;G;K;J;Y;E;Z;head;L;M;N;U;F;poolpoints;roadvectors[1]   ⍝Find vernal pools that fell on road cells, and move them to non-road cells in the right direction[2]   ⍝Implemented as a CAPS block metric[3]   ⍝Must run makemovepools.aml first to prepare vector data[4]   ⍝Source data (all in source\):[5]   ⍝   luwet           land use/wetlands[6]   ⍝   roads           roads grid[7]   ⍝   trains          railroads grid[8]   ⍝   streams         streams grid[9]   ⍝   roadlines.txt   vector roads, text version, from makeroads.aml[10]  ⍝   trainlines.txt  vector trains, text version[11]  ⍝   pools.txt       text file of pools, from makemovepools.aml[12]  ⍝Parameters:[13]  ⍝   buffer         number of extra cells to read around edges; limits how far pools can move.  Probably 1 or 2[14]  ⍝   reach          meters beyond block to look for road segments; keeps roads with both endpoints outside of block[15]  ⍝   roads          classes to treat as roads (include railroads & culverts).  Done the old-fashioned way for the sake of kernel pools[16]  ⍝   pool           class for vernal pools[17]  ⍝   avoid          classes of landcover to avoid moving pools to (streams)[18]  ⍝Results (in results\):[19]  ⍝   newluwet       new version of luwet, with pools moved out from under roads.  If it looks good, replace source\luwet with this.[20]  ⍝   movedpools.txt new version of pools.txt, with old and new coordinates[21]  ⍝B. Compton, 11 Feb 10[22]  ⍝21 May 2010: use LOCKWRITE[23]  ⍝7-13 Dec 2010: revisions for CAPS 3.0.  For kernel pools or other uses with integrated land cover, use MOVEPOOLSLC[24]  ⍝22 Nov 2013: don't keep vector data in memory--it leads to inter-run interactions in Anthill![25]  [26]  [27]  [28]   READPARS ME[29]   buffer←B←4⊃A[30]   ⍞←'Reading vector data...' ⋄ FLUSH[31]   poolpoints←MATIN pathS PATH 'pools.txt'                ⍝   potential vernal pools[32]   T←(MATIN pathS PATH 'roadlines.txt')[;⍳4]              ⍝   road + trains together; don't care about classes[33]   roadvectors←T⍪(MATIN pathS PATH 'trainlines.txt')[;⍳4][34]   ⎕←'done' ⋄ FLUSH[35]  [36]   X←READ pathS PATH 1⊃1⊃A                              ⍝Read luwet[37]   L←(MV≠READ pathG PATH 2⊃1⊃A)∨MV≠READ pathG PATH 3⊃1⊃A  ⍝and combined roads/railroads[38]   M←MV≠READ pathG PATH 4⊃1⊃A                             ⍝and streams[39]   C←(1 ¯1×cellsize÷2)+FINDPOINT block[1 2]×block[4 5]-1  ⍝Upper left corner of block in map coordinates[40]   C←C,C+cellsize×1 ¯1×(⍴X)-2×buffer                      ⍝and lower right corner[41]   D←C+¯1 1 1 ¯1×reach                                    ⍝Expand block by reach (= longest road vector)[42]   V←((poolpoints[;2]≥C[1])^(poolpoints[;2]≤C[3])^(poolpoints[;3]≥C[4])^poolpoints[;3]≤C[2])⌿poolpoints       ⍝Pools in block[43]   Q←(roadvectors[;1]≥D[1])^(roadvectors[;1]≤D[3])^(roadvectors[;2]≥D[4])^roadvectors[;2]≤D[2]                ⍝Roads in block[44]   R←(Q∨(roadvectors[;3]≥D[1])^(roadvectors[;3]≤D[3])^(roadvectors[;4]≥D[4])^roadvectors[;4]≤D[2])⌿roadvectors[45]  [46]   G←(↑1 FINDCELL¨↓V[;2 3])                               ⍝Locations of PVPs in grid[47]   P←((pool=X SCATI G)^L SCATI G)/⍳1↑⍴V                   ⍝Pools that (1) fall on roads and (2) are actually mapped as pools in luwet[48]   Z←((⍴P),2)⍴0[49]   J←↓8 2⍴¯1 ¯1 ¯1 0 ¯1 1 0 ¯1 0 1 1 ¯1 1 0 1 1[50]   I←0[51]  L2:→((⍴P)<I←I+1)/L3                                     ⍝For each pool that falls on a road,[52]   BREAKCHECK[53]   K←↑J+¨⊂F←1 FINDCELL V[P[I];2 3]                        ⍝   Eight neighbors (row-major order)[54]   T←X SCATI K                                            ⍝   Neighboring cells[55]   N←(U←T≠¯1↓0,T←T[⍋T]) pSUM (⍴T)⍴1[56]   N←''⍴(U/T)[⍒N]                                         ⍝   Replacement value: focal majority; use lowest class for ties[57]   K←↑1 FINDPOINT¨↓K                                      ⍝   Centerpoints of 8 neighbors[58]   Y←∨/↑((⊂2 2)⍴¨↓K,8 2⍴V[P[I];2 3]) CROSS¨⊂R             ⍝   1 for cells across the road[59]   Q←(L∨M) SCATI ↑J+¨⊂G[P[I];]                            ⍝   1 for road and stream cells[60]   E←(+/(K-8 2⍴V[P[I];2 3])*2)*.5                         ⍝   distance from pool to each cell center[61]   E←(⌊/(E≠0)/E)=E←(~Y∨Q)×E                               ⍝   closest cell center not in a grid road cell nor across vector road[62]   →(0∊Z[I;]←1 2↑E⌿K)/L2                                  ⍝   that's our new vp point (if there is one)[63]   X[F[1];F[2]]←N                                         ⍝   If we've moved pool, replace focal cell with focal majority[64]   →L2[65]  [66]  [67]  L3:X←X SCATR ((∨/Z≠0)⌿↑1 FINDCELL¨↓Z) pool              ⍝Add new pools to landcover[68]   X WRITEI pathR PATH 3⊃A[69]   →(0∊⍴Z)/0[70]  [71]   (V[P;],Z) LOCKWRITE pathR PATH 'movedpools.txt'        ⍝Write new points to movedpools.txt[72]   →0[73]  [74]  what:data prep[75]  type:standard[76]  info:((⊂pathS),¨'luwet' 'roads' 'trains' 'streams') ('') ('newluwet') (buffer) 'luwet'      ⍝Source grids, settings table, result grid, and buffer size[77]  check:CHECKVAR 'reach'[78]  check:CHECKVAR 'buffer'[79]  init:head←1↓⎕TCHT MTOV MATRIFY 'pvp_number x-coord y-coord new-x new-y' ⋄ (0 0⍴'') TMATOUT pathR PATH 'movedpools.txt' ⍝(Re)create points file on start[80]  init:LOG '--->>> Run FINISHMOVEPOOLS when finished <<<---'    ∇