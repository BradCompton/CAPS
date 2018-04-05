﻿    ∇ L IEISTATS2 F;X;U;B;Z;head[1]   ⍝Produce summary tables from IEISTATS result table ⍵; flagging range ⍺[2]   ⍝Adds a flag for any values outside of range ⍺[1],⍺[2][3]   ⍝B. Compton, 20 Mar 2017[4]   ⍝30 Mar 2017: fixed more bugs than you can imagine; and no, don't drop development--it screws up means![5]   [6]   [7]   [8]    ⍎(0=⎕NC'L')/'L←0.48 0.52'[9]    SETPATHS[10]   X←1 ⎕TCHT MATIN pathW PATH F[11]  [12]   U←UNIQUE X[;1]                     ⍝By region[13]   X←X[⍋X[;1];][14]   B←X[;1]≠¯1↓0,X[;1][15]   Z←(B/X[;1]),((B pSUM X[;5])÷B pSUM X[;4]),[1.5]B pSUM X[;4][16]   Z←Z,' *'[1+(Z[;2]<L[1])∨Z[;2]>L[2]][17]   head←1↓⎕TCHT MTOV MATRIFY 'Region Mean Count Flagged'[18]   Z TMATOUT pathW PATH (STRIPPATH F),(STRIP F),'_regions.txt'[19]   [20]   U←UNIQUE X[;2]                     ⍝By region[21]   X←X[⍋X[;2];][22]   B←X[;2]≠¯1↓0,X[;2][23]   Z←(B/X[;3]),((B pSUM X[;5])÷B pSUM X[;4]),[1.5]B pSUM X[;4][24]   Z←Z,' *'[1+(Z[;2]<L[1])∨Z[;2]>L[2]][25]   head←1↓⎕TCHT MTOV MATRIFY 'System Mean Count Flagged'[26]   Z TMATOUT pathW PATH (STRIPPATH F),(STRIP F),'_systems.txt'    ∇