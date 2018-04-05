﻿    ∇  Z←A MATIOTA B;T;V;W;Y[1]    ⍝Looks up rows of ⍵ in matrix ⍺.  Returns row indices or 0 if not found[2]    ⍝ The args may be character or numeric scalars, vectors, or matrices.[3]    ⍝ The result is a vector if B is a matrix, or is a scalar if B is a[4]    ⍝    vector or scalar.[5]    ⍝[6]   L1:→(T←''⍴(⎕STPTR'Z A B T')⎕CALL MATIOTA∆OBJ)↓0[7]   [8]    ⍝ If the args are numeric and have different types, coerce to same type:[9]    →(T≠6)/L2 ⍝jump if asm code didn't signal nonce error[10]   Y←(⎕DR A),⎕DR B[11]   W←⌈/Y ⍝worse type of A and B[12]   →(W=11)/L3 ⍝jump if both args are Boolean[13]   T←''⍴(323 645⍳W)⊃(,2-2) (,.5-.5) ⍝0, in worse type (int or real)[14]   →(W=1↑Y)/L4 ⋄ A←T+A ⍝coerce A if not already worse type[15]  L4:→(W=1↓Y)/L1 ⋄ B←T+B ⍝coerce B...[16]   ⍝ ↑ Branch to avoid unnecessary conversion in case args are Really Big.[17]   →L1 ⍝retry[18]   ⍝[19]   ⍝ Boolean case: pad to even byte width, convert to character using ⎕DR:[20]  L3:A←1/A ⋄ B←1/B ⍝ravel scalars[21]   V←¯1↑⍴A ⋄ W←¯1↑⍴B ⍝widths[22]   T←5 ⋄ →(V≠W)/L2 ⍝err of widths don't match[23]   ⍝ ↑ This has to be done because once A and B are character type,[24]   ⍝   MATIOTA will happily pad the narrower with blanks, possibly[25]   ⍝   resulting in incorrect answers.[26]   A←((⍴A)⌈(-⍴⍴A)↑8×⌈V÷8)↑A ⍝pad to multiple of 8 columns[27]   B←((⍴B)⌈(-⍴⍴B)↑8×⌈W÷8)↑B[28]   A←82 ⎕DR A ⋄ B←82 ⎕DR B[29]   →L1 ⍝retry[30]  [31]  L2:⎕ERROR(1 2 3 5⍳T)⊃'RANK ERROR' 'WS FULL' 'VALUE ERROR' 'LENGTH ERROR' 'DOMAIN ERROR'[32]   ⍝ Copyright (c) 1988, 1989, 1994, 1995, 2000 by Jim Weigang    ∇