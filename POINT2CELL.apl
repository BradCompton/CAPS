﻿    ∇ Z←W POINT2CELL XY[1]   ⍝Give r,c of cell x,y ⍵ given window ⍺ (ncol, nrow, xll, yll, cellsize)[2]   ⍝B. Compton, 8 Oct 2013[3]   [4]   [5]   [6]    Z←⌈(W[2]-(XY[2]-W[4])÷W[5]),(XY[1]-W[3])÷W[5]    ∇