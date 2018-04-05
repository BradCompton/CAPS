﻿    ∇ A ∆GRIDCOPY B;Q;err;K;M;firstfail[1]   ⍝Copy grid to ⍵[2]   ⍝B. Compton, 18 Feb 2009; E. Ene, 6 Feb 2009[3]   ⍝2 May 2011: set global gridwait for task manager[4]   ⍝5 Nov 2013: copy mosaics too[5]   ⍝26 Nov 2013: split from GRIDCOPY; don't do mosaics[6]   ⍝5 Dec 2013: use 8.3 paths to keep Arc from crashing on otherwise legal long names[7]   ⍝9 Dec 2013: shorten the source path, but not grid name--this causes ∆GRIDCOPY to fail![8]   ⍝12 Dec 2013: remove SHORTPATH calls: they were provoking random hard-to-find hangs in CAPS_LIB.gridcopy. Thanks, ESRI![9]   [10]  [11]  [12]   →(aplc=1)/0                        ⍝If C version,[13]   →(3=⎕NC'GRIDCOPYc')/L1             ⍝   If not loaded,[14]   Q←⎕EX 'GRIDCOPYc'[15]   ⎕ERROR REPORTC 'DLL I4←CAPS_LIB.gridcopy(*C1, *C1)' ⎕NA 'GRIDCOPYc'[16]  ⍝⎕←'CAPS_LIB.gridcopy loaded.'[17]  [18]  L1:K←⎕AI[2][19]  L3:err←GRIDCOPYc (A,⎕TCNUL) (B,⎕TCNUL)[20]   →(RECOVERY err)/L3         ⍝Wait for crashed grid servers to recover[21]   GRIDWAIT K[22]   ⎕ERROR REPORTC err    ∇