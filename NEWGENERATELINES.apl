﻿    ∇ F NEWGENERATELINES X;B;I;Q;Z;T;J[1]   ⍝Write file ⍺ as input to Arc GENERATE command to create line coverage from lines ⍵[2]   ⍝B. Compton, 20 Jul and 3 Aug 2010[3]   [4]   [5]    '' NWRITE F[6]    I←J←0[7]    B←^/X[;3 4]=1⊖X[;1 2]         ⍝Get segments that make up a line[8]   L1:BREAKCHECK ⋄ DOT[9]    Q←X[⍳T←+/^\B;][10]   Z←(DEB⍕I←I+1),⎕TCNL[11]   Q←Q[;1 2]⍪Q[1↑⍴Q;3 4][12]   Z←Z,1↓MTOV (DEB⍕Q[;,1]),',',(DEB⍕Q[;,2])[13]   Z←Z,⎕TCNL,'end'[14]   Z NAPPEND F[15]   →((1↑⍴X)>J←J+T)/L1[16]   (⎕TCNL,'end') NAPPEND F    ∇