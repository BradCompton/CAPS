﻿    ∇ Z←F NEXTFLOW2 I[1]   ⍝Flow from cell ⍵ following flow grid ⍺, using directions fd[2]   [3]    Z←0 ⋄ →(F[I[1];I[2]]≤0)/0   ⍝Off edge? Or flowing into zero cell?[4]    Z←(1+⍴F)|I+fd[fd[;1]⍳F[I[1];I[2]];2 3]    ∇