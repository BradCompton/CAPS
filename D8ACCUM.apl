﻿    ∇ D8ACCUM;X;override_metrics;override_pars;tile;buffer;weights[1]   ⍝Set up CAPS D8 flow accumulation run[2]   ⍝B. Compton, 12 Dec 2013[3]   [4]   [5]   [6]    INIT[7]    READPARS 'd8flowaccum'[8]   [9]    X←1 4⍴'D8FLOWACCUM' 'yes' '*' tile[10]   X←X⍪4↑⊂'@wait'[11]   X←X⍪'D8LOOP' 'yes' '*' 0[12]  [13]   GRIDKILL pathR PATH GRIDNAME 'd8accum'     ⍝Kill result grid here, as it doesn't happen at launch[14]  [15]   override_metrics←X[16]   override_pars←('.|.',⎕TCNL) TEXTREPL '[caps]|project = ''D8accum(1)''|post = 0'[17]   CAPSx[18]  [19]   CLEAR    ∇