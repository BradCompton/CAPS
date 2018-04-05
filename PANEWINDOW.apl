﻿    ∇ Z←D PANEWINDOW P;C;L;I;J;Y[1]   ⍝Return GRIDDESCRIBE-style window into pane ⍵ of mosaic window ⍺[2]   ⍝   ⍵ = rowsize, colsize, pane index[3]   ⍝   ⍺ = Mosaic window: cols, rows, xll, yll, cellsize[4]   ⍝   returns (pane window: cols, rows, xll, yll, cellsize) (READBLOCK args: start row, start col, rows, cols)[5]   ⍝   use 1st result for setting window to pane, 2nd for reading/writing block in full mosaic[6]   ⍝B. Compton, 5-6 Sep 2013. From THISBLOCK.[7]   [8]   [9]   [10]   C←⌈D[2 1]÷P[1 2]                       ⍝Number of pane rows and columns[11]   L←1+P[1 2]|¯1+D[2 1]                   ⍝Number of cell rows and columns in last row and column[12]   I J ← (⌈P[3]÷C[2]) (1+C[2]|P[3]-1)     ⍝Pane row and column[13]  [14]   Z←5⍴0 ⋄ Y←4⍴0[15]  [16]   Z[1]←(1+J=C[2])⊃P[2],L[2]              ⍝Cell columns in tile[17]   Z[2]←(1+I=C[1])⊃P[1],L[1]              ⍝Cell rows in tile[18]   Z[3]←D[3]+D[5]×P[2]×J-1                ⍝Xll[19]   Z[4]←D[4]+(D[5]×P[1]×0⌈¯1+C[1]-I)+D[5]×L[1]×I<C[1]  ⍝Yll[20]   Z[5]←D[5]                              ⍝Cell size[21]  [22]   Y[1]←1+P[1]×I-1                        ⍝Start row[23]   Y[2]←1+P[2]×J-1                        ⍝Start column[24]   Y[3 4]←Z[2 1]                          ⍝Cell rows, columns in tile[25]  [26]   Z←Z Y    ∇