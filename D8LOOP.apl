﻿    ∇ A D8LOOP S;X;B;purge;Y;T;I;N;P;O;Q;M;targets;block;tile;buffer;Z;head[1]   ⍝Handle project looping for D8FLOWACCUM[2]   ⍝B. Compton, 12 Dec 2013[3]   ⍝17-18 Dec 2013: major revision: instead of rerunning project, launch new one only for necessary tiles[4]   ⍝19 Dec 2013: more revisions; make this a table metric; use targets = '1:1' to just run once[5]   ⍝23 Dec 2013: end properly when there are errors, and write point file of loops[6]   ⍝27 Jan 2014: use SETTILE instead of noread←1 nonsense[7]   ⍝25 Sep 2015: minor bug in ⍎[8]   [9]   [10]  [11]   READPARS 'd8flowaccum'[12]   :if IFEXISTS Q←pathI,'d8accumtiles.txt'[13]      X←0 MATIN pathI,'d8accumtiles.txt'              ⍝Read progress file[14]   :else[15]      X←0[16]   :end[17]  [18]   T←⊃tasks[tasks[;tasks_ COL 'project task'] FINDI project 1;tasks_ COL 'command'][19]   ⍎'Y←.BLOCKREPS.GETTILEMAP.SINK.' TEXTREPL T        ⍝Read tilemap[20]  [21]   N←1↑⍴MATIN ⊃tasks[tasks[;tasks_ COL 'project task'] FINDI project 2;tasks_ COL 'sublist']      ⍝Number of subtasks in this iteration[22]   :if N=T←+/~Y/,X                                    ⍝If nothing was changed on this iteration,[23]      LOG project,': --- D8accum is finished, but there were loop errors in ',(⍕T),' tiles ---'[24]      N←INDICES ((⍴X)⍴Y)^X=0                          ⍝   Tiles with errors[25]      BLOCK (2⍴tile),buffer                           ⍝   now go find error points[26]      SETTILE[27]      Z←0 2⍴0[28]      :for I :in ⍳1↑⍴N                                ⍝   For each tile with errors,[29]         block[4 5]←N[I;][30]         X←READ GRIDNAME pathR,'d8accum'              ⍝      read tile of d8accum[31]         Y←READ GRIDNAME pathS,'flow'                 ⍝      and tile of flow[32]         Q←(X=MV)^Y≠MV[33]         Z←Z⍪↑1 FINDPOINT¨↓INDICES Q                  ⍝      points of cells that were't done--these are involved in loops[34]      :end[35]      head←'x-coord',⎕TCHT,'y-coord'[36]      Z TMATOUT T←pathP,'d8flowerrors.txt'            ⍝   write errors file[37]      LOG project,': Error points written to ',T ⋄ FLUSH[38]      →0[39]   :end[40]  [41]  [42]   (⍕Y/~,X) NWRITE M←pathI,'d8todo.txt'               ⍝Write vector of tiles left to do[43]   (1↓MTOV ' -+'[1+X+(⍴X)⍴Y]) NWRITE pathI,'d8progress.txt'  ⍝Write progress map[44]  [45]   LOG project,': ',(⍕+/,X),' tiles finished of ',(⍕+/,Y),' (',(⍕2 ROUND 100×(+/,X)÷+/,Y),'% done).' ⋄ FLUSH[46]   :if (+/,X)=+/Y                                     ⍝If all tiles are done,[47]      LOG project,': --- D8accum is finished ---'     ⍝   no more iterations[48]      →0[49]   :end[50]   LOG project,': --- Launching next iteration for D8accum ---'[51]  [52]   X←1 4⍴'D8FLOWACCUM' 'yes' '*' tile[53]   X←X⍪4↑⊂'@wait'[54]   X←X⍪'D8LOOP' 'yes' '*' 0[55]  [56]   I←0 ¯1+(P←project)⍳'()'[57]   A←P[⍳I[1]],(⍕1+N←⎕FI I[1]↓I[2]↑P),I[2]↓P           ⍝Project name = this one+1[58]   O←P[⍳I[1]],(⍕N-1),I[2]↓P                           ⍝Previous project name = this one-1[59]  [60]   :if purge[61]      PURGEPROJECT O                                  ⍝Purge previous project[62]   :end[63]  [64]   override_metrics←X[65]   override_pars←('.|.',⎕TCNL) TEXTREPL '[caps]|project = ''',A,'''|post = 0|tilebits = ''',M,'''|[d8flowaccum]|progress = ''',pathI,'d8accumtiles.txt'''[66]  [67]   CAPSx[68]   →0[69]  [70]  [71]  what:data prep[72]  type:table[73]  info:('') ('') ('') (0) 'include'               ⍝Source grid, settings table, result grid, buffer size, and include grid[74]  check:CHECKVAR 'purge targets'    ∇