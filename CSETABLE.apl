﻿    ∇ Z←CSETABLE N;Q;R[1]   ⍝Return crossings/dams/tidal restrictions table ⍵ with cell #s for CSE[2]   ⍝Reads the table the first time, then keeps it in memory for subsequent calls[3]   ⍝B. Compton, 6 Jul 2012[4]   ⍝8 Jul 2013: give table name -x on end to prevent conflicts; 27 Nov: and test for -x, duh.[5]   ⍝24 Apr 2014: aargh! name collision when using 'row' - go to cellrow, cellcol[6]   [7]   [8]   [9]    →(2=⎕NC N,'x')/L1                              ⍝If need to read in the table,[10]   Q R ← GETTABLE pathT PATH N,'.txt'             ⍝   Read table & header[11]   Q←Q,↑FINDCELL¨↓Q[;⌈⌿2 2⍴R MATIOTA MATRIFY 'x-coord y-coord x.coord y.coord'][12]   R←R OVER MATRIFY 'cellrow cellcol'             ⍝   add cell #s[13]   ⍎N,'x ',N,'x_ ← Q R'                           ⍝   save it in memory[14]  L1:Z←⍎N,'x ',N,'x_'                             ⍝Return table    ∇