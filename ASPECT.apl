﻿    ∇ Z←ASPECT E;B;C;L[1]   ⍝Give aspect from elevation grid ⍵[2]   ⍝Bogus values for edges[3]   ⍝B. Compton, 9 Jun 2010[4]   [5]   [6]    B←((1⌽¯1⊖E)+(2×1⌽E)+(1⌽1⊖E)+(-¯1⌽¯1⊖E)+(-2×¯1⌽E)-¯1⌽1⊖E)÷8×cellsize[7]    C←((¯1⌽¯1⊖E)+(2×¯1⊖E)+(1⌽¯1⊖E)+(-¯1⌽1⊖E)+(-2×1⊖E)-1⌽1⊖E)÷8×cellsize[8]    Z←(360×(C<0)^B>0)+(180×C>0)+DEG ¯3○B÷C+(C=0)×÷⌊/⍳0    ∇