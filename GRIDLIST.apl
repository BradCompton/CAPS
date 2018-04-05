﻿    ∇ Z←GRIDLIST P;S;Q;err;A;firstfail[1]   ⍝Return list of grids in absolute path ⍵ (default = root folder)[2]   ⍝B. Compton, 18 Feb 2009; E. Ene, 19 Feb 2009[3]   ⍝2 May 2011: set global gridwait for task manager[4]   ⍝13 Nov 2013: add grid server recovery[5]   [6]   [7]   [8]    →(aplc=1)/0                       ⍝If C version,[9]    →(3=⎕NC'GRIDLISTc')/L1            ⍝   If not loaded,[10]   Q←⎕EX 'GRIDLISTc'[11]   ⎕ERROR REPORTC 'DLL I4←CAPS_LIB.gridlist(*C1,*C1←)' ⎕NA 'GRIDLISTc'[12]  ⍝⎕←'CAPS_LIB.gridlist loaded.'[13]  [14]  L1:Z←0 0⍴'' ⋄ →(~IFEXISTS P←FRDBL P)/0[15]   S←(9999⍴' '),⎕TCNUL[16]   A←⎕AI[2][17]  L3:err Z←GRIDLISTc P S,¨⎕TCNUL[18]   →(RECOVERY err)/L3         ⍝Wait for crashed grid servers to recover[19]   GRIDWAIT A[20]   Z←MATRIFY FRDBL (Z≠⎕TCNUL)/Z[21]   ⎕ERROR REPORTC err    ∇