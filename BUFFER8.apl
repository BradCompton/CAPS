﻿    ∇ Z←N BUFFER8 X;I[1]   ⍝Buffer ⍵ by ⍺ (default=1) cells, using 8-neighbor rule[2]   ⍝This doesn't match pattern of polygon buffering (corners are over-buffered); need BUFFERTRUE function[3]   [4]   [5]    ⍎(0=⎕NC'N')/'N←1'[6]    Z←(-N+N+⍴X)↑(N+⍴X)↑X[7]    I←0[8]   L1:→(N<I←I+1)/L2[9]    Z←Z⌈(1⌽Z)⌈(¯1⌽Z)⌈(1⊖Z)⌈(¯1⊖Z)⌈(1⌽1⊖Z)⌈(1⌽¯1⊖Z)⌈(¯1⌽1⊖Z)⌈¯1⌽¯1⊖Z[10]   →L1[11]  L2:Z←(2⍴N)↓(-2⍴N)↓Z    ∇