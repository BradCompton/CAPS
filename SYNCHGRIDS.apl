﻿    ∇ SYNCHGRIDS P;L;pathdir;R;I;Y;M;A;B;Z;T;J;D;C[1]   ⍝Find differences among all grids in subdirectories with the same names below two root paths named in ⍵[2]   ⍝Finds paths on disk and finds all grids within; compares grid[3]   ⍝size, position, and stats.[4]   ⍝Example:[5]   ⍝   SYNCHGRIDS 'd:\gis\ z:\gis\'[6]   ⍝For each directory, shows ←grids in left only, →grids in right only, ≠grids that differ[7]   ⍝Note: sister function SYNCHCAPSGRIDS does the same thing for CAPS directories[8]   ⍝B. Compton, 7 Mar 2011, from SYNCHCAPSGRIDS[9]   [10]  [11]   GRIDINIT ''[12]   P←TOLOWER MATRIFY P[13]   A←,⊂P[1;]                      ⍝Left and right paths[14]   B←,⊂P[2;][15]   I←0[16]  L0:→((⍴A)<I←I+1)/L4             ⍝For each path in our expanding list,[17]   C←TOLOWER¨SUBDIRS I⊃A[18]   D←TOLOWER¨SUBDIRS I⊃B[19]   A←A,(⊂FRDBL I⊃A),¨T←(C∊D)/C    ⍝Shared subdirectories[20]   B←B,(⊂FRDBL I⊃B),¨T[21]   A←A,(⊂FRDBL I⊃A),¨C~D          ⍝Subdirectories in left only[22]   B←((⍴A)⌈⍴B)↑B                  ⍝Match lines[23]   B←B,(⊂FRDBL I⊃B),¨D~C          ⍝and in right only[24]   A←((⍴A)⌈⍴B)↑A                  ⍝Match lines[25]   →L0[26]  [27]  L4:⎕←''[28]   ⎕←'Comparing grids in directories:'[29]   ⎕←('Left' OVER '-'⍪MIX A),' ','|',' ','Right' OVER '-'⍪MIX B[30]   ⎕←''[31]  [32]   A[(^/¨A=¨' ')/⍳⍴A]←⊂'<non-existent>'[33]   B[(^/¨B=¨' ')/⍳⍴B]←⊂'<non-existent>'[34]  [35]   I←0[36]  L1:→((⍴A)<I←I+1)/0                          ⍝For each path,[37]   L←GRIDLIST I⊃A                             ⍝   Left grids[38]   R←GRIDLIST I⊃B                             ⍝   Right grids[39]   →((0∊⍴L)^0∊⍴R)/L1                          ⍝   If any grids,[40]   Z←(0=L MATIOTA R)⌿'→',R                    ⍝      Grids in right but not left[41]   Z←Z OVER (T←0=R MATIOTA L)⌿'←',L           ⍝      and left but not right[42]   Y←(~T)⌿L                                   ⍝      grids in both[43]   J←0[44]  L2:→((1↑⍴Y)<J←J+1)/L3                       ⍝      For each grid in both,[45]   Z←Z OVER (~(1 GRIDDESCRIBE (FRDBL I⊃A) PATH Y[J;])≡1 GRIDDESCRIBE (FRDBL I⊃B) PATH Y[J;])⌿'≠',Y[,J;][46]   →L2[47]  L3:⎕←(I⊃A),' ←→ ',I⊃B[48]   ⎕←' ',' ',' ',40 TELPRINT Z[49]   ⎕←''[50]   →L1    ∇