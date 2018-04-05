﻿    ∇ SUMMARIZE_RESIL_IMPACT W;X;I;Q;Z;Y;H;head;scenarios;scenarios_;P[1]   ⍝Build summary tables from RESIL_IMPACT result tables for ⍵ = 'eco' or 'geo'[2]   ⍝B. Compton, 5 Dec 2017[3]   ⍝2 Feb 2018: work with either eco or geo results[4]   [5]   [6]   [7]    READPARS 'resil_impact'[8]    scenarios←1 TABLE scenarios                        ⍝Read scenarios file[9]    scenarios_←(',',⎕TCHT) MATRIFY '.".' TEXTREPL head ⍝and get header[10]   scenarios←((⍴scenarios)⌈0,1↑⍴scenarios_)↑scenarios,⊂''[11]   P←⊃scenarios[1;scenarios_ COL 'deltas']        ⍝Path to summary tables[12]   X←1 0↓scenarios[;scenarios_ COL 'name'],[1.5](⊂P),¨(⊂'resil_impact_',W,'_'),¨scenarios[;scenarios_ COL 'name'],¨⊂'.txt'[13]  [14]  [15]   I←0[16]  L1:→((1↑⍴X)<I←I+1)/L2[17]   Q←1 ⎕TCHT MATIN ⊃X[I;2][18]   :if I=1[19]      Z←Y←((1↑⍴Q),1+1↑⍴X)⍴0[20]      Z[;1]←Y[;1]←Q[;1]       ⍝System/formation/geophysical setting names[21]      H←(⊂FRDBL (⎕TCHT MATRIFY head)[1;]),X[;1][22]   :end[23]   Y[;I+1]←Q[;2]              ⍝Deltas[24]   Z[;I+1]←Q[;3]              ⍝Impact[25]   →L1[26]   [27]  L2:Z←Z⍪(⊂'Overall'),+⌿0 1↓Z[28]   Y←Y⍪(⊂'Overall'),+⌿0 1↓Y[29]  [30]   head←1↓⊃,/⎕TCHT,¨H[31]   Y TMATOUT P,'resil_',W,'_deltas.txt'[32]   Z TMATOUT P,'resil_',W,'_impact.txt'[33]  [34]   Z←Z[;1],100×(0 1↓Z)÷⍉(⌽0 ¯1+⍴Z)⍴Z[;2][35]   Z TMATOUT P,'resil_impact_',W,'_percent.txt'    ∇