﻿    ∇ A D8FLOWACCUM S;weights;buffer;Z;F;L;B;E;I;C;W;transparent;Q;M;T;V;X;head;tile;progress;D;R[1]   ⍝Create D8 flow accumulation grid for an arbitrarily large landscape[2]   ⍝Like flowaccumulation in Arc/grid with two differences:[3]   ⍝   1. It runs in parallel on the cluster[4]   ⍝   2. It doesn't run forever if there are loops in the flow grid[5]   ⍝Source:[6]   ⍝   flow        Depressionless D8 flow direction grid.[7]   ⍝   weights     (optional) Weights for each cell (default = 1). Can use this for precipitation[8]   ⍝               and for inflow on major rivers.[9]   ⍝Parameters:[10]  ⍝   buffer      How much overlap between tiles?  A fair amount should speed up the process.[11]  ⍝   weigths     Name of weights grid.[12]  ⍝Result:[13]  ⍝   d8accum     Grid of D8 flow accumulation.  Areas outside of the landscape (where flow = nodata)[14]  ⍝               will be 0.  Cells where there were loops will be nodata--these are errors.[15]  ⍝****** NOTE: don't run this metric directly--instead use D8ACCUM to launch it ******[16]  ⍝Why do we have to rewrite all of ESRI's software ourselves?![17]  ⍝B. Compton, 11-13 Dec 2013[18]  ⍝16 Dec 2013: plus, comma, whatever....[19]  ⍝17-19 Dec 2013: new version writes progress matrix d8accumtiles.txt[20]  ⍝21 Dec 2013: make sure progress file exists even if we haven't changed anything--necessary for endgame when loops in flow[21]  ⍝31 Dec 2013: treat missing weights as 1[22]  ⍝24 Sep 2015: oops--use results.par for result[23]  [24]  [25]  [26]   READPARS ME[27]   buffer←4⊃A[28]   A[3]←⊂pathR PATH 0 'results.par' GRIDNAME 'd8accum'[29]   :if IFGRIDEXISTS 3⊃A                       ⍝If result grid has been created yet,[30]      Z←1 READ 3⊃A                            ⍝   read it (without caching!)[31]   :end[32]   F←READ 1⊃A                                 ⍝Read flow grid[33]   :if 0=⎕NC'Z'                               ⍝If we haven't read the result grid,[34]      Z←(⍴F)⍴MV                               ⍝   it's empty[35]   :end[36]   :if ~0∊⍴weights                            ⍝If weights grid is supplied, use it; otherwise weights are all 1[37]      W←READ GRIDNAME weights[38]      W←1 MVREP W[39]   :else[40]      W←(⍴F)⍴1[41]   :end[42]   Z←Z×F≠MV                                   ⍝Set cells outside of the landscape to 0[43]  [44]   :if ~MV∊(2⍴buffer)↓(-2⍴buffer)↓Z           ⍝If no missing data in core of result grid,[45]      ⎕←'  -- Tile ',(1↓⊃,/',',¨FRDBL¨⍕¨block[4 5]),' is finished.' ⋄ FLUSH[46]      D←E←1[47]      →L8                                     ⍝   this tile is done - write progress file[48]   :end[49]  [50]   B←(⍴Z)⍴0                                   ⍝Mark border cells[51]   B[1,1↑⍴B;]←1[52]   B[;1,1↓⍴B]←1[53]   L←0,INDICES (~B)×Z=MV                      ⍝Make index of done, i, j of undone cells in result...excluding border cells[54]   M←3 3⍴2 4 8 1 999 16 128 64 32             ⍝Pattern of flow directions for neighbors that flow into focal cell[55]   S←+/,~Z∊MV,0[56]   E←0                                        ⍝Flag for ever changed[57]  [58]  L0:C←I←0                                    ⍝While (clear changed flag),[59]   ⍞←'Tile ',(1↓⊃,/',',¨FRDBL¨⍕¨block[4 5]),' (',(⍕5 ROUND 100×(+/,Z>0)÷+/,Z≠0),'% done)...' ⋄ FLUSH[60]  L1:→((1↑⍴L)<I←I+1)/L2                       ⍝   For each cell that's not finished,[61]   ⍝N←F FLOWINTO L[I;2 3]                      ⍝      cells that flow into focal cell[62]   ⍝:if ~MV∊Q←Z SCATI N                        ⍝      if no inflows are missing,[63]   Q←(,M=F[T;V])/,Z[T←L[I;2]+¯1 0 1;V←L[I;3]+¯1 0 1]  ⍝      Values of cells flow into focal cell[64]   :if ~MV∊Q                                  ⍝      if no inflows are missing,[65]      Z[L[I;2];L[I;3]]←+/Q,W[L[I;2];L[I;3]]   ⍝         result is sum of inflows plus weight for this cell[66]      L[I;1]←C←1                              ⍝         mark cell as done and set changed flag[67]   :end[68]   →L1                                        ⍝   next cell[69]  [70]  L2:BREAKCHECK[71]   :if C                                      ⍝   If any cells have been changed,[72]      ⎕←(⍕+/L[;1]), ' cells changed.' ⋄ FLUSH[73]      E←1                                     ⍝      set ever changed[74]      L←(~L[;1])⌿L                            ⍝      drop finished cells from list[75]      →(0≠1↑⍴L)/L0                            ⍝      and start another pass through data[76]   :end[77]  [78]   ⎕←⎕TCNL,'Done with tile ',(T←1↓⊃,/',',¨FRDBL¨⍕¨block[4 5]),'. ',((1+E)⊃'Nothing' ((FRDBL ,'CI15' ⎕FMT (+/,~Z∊0,MV)-S),' cells were')),' changed.' ⋄ FLUSH[79]   ⍞←(D←^/,MV≠(2⍴buffer)↓(-2⍴buffer)↓Z)/'>>>>> Tile ',T,' is finished! <<<<<' ⋄ FLUSH[80]  [81]   Z←MVREP Z (Z=0)                            ⍝Replace zeros with MV[82]   transparent←1[83]   Z WRITE 3⊃A                                ⍝Save results transparently[84]  [85]  L8:R←LOCKFILE Q←pathI,'d8accumtiles.txt'    ⍝Get a lock on progress file[86]   T←⎕DL 1                                    ⍝Wait a sec for shitty windows file system to catch up[87]   :if ~IFEXISTS Q                            ⍝If progress file doesn't exist yet (we'll create it even if we did't change anything),[88]      :if 0∊⍴progress                         ⍝   If progress wasn't passed from last run[89]         X←(block[6 7])⍴0                     ⍝      create it[90]      :else                                   ⍝   else,[91]         X←0 MATIN progress                   ⍝      read progress file from previous run[92]      :end[93]      X[block[4];block[5]]←D                  ⍝   mark our tile done[94]      head←''[95]      X TMATOUT Q                             ⍝   and write file back out[96]   :else[97]      :if E                                   ⍝If we've ever changed any values,[98]         X←0 MATIN Q                          ⍝   read progress file[99]         X[block[4];block[5]]←D               ⍝   mark our tile done[100]        head←''[101]        X TMATOUT Q                          ⍝   and write file back out[102]     :end[103]  :end[104]  UNLOCKFILE R[105]  →0[106] [107] [108] [109] what:data prep[110] type:standard[111] info:(pathS PATH 'flow') ('') ('') (1⌈buffer) 'include'      ⍝Source grid, settings table, result grid, buffer size, and include grid[112] check:CHECKVAR 'buffer weights tile progress'    ∇