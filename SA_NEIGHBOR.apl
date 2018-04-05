﻿    ∇ Z←A SA_NEIGHBOR X;I;K;Q;F;T;M;V[1]   ⍝Subroutine of SA, gives S' from ⍵ by moving ⍺ selected cells[2]   ⍝Use costs 2⊃⍺ to modify probability of moving cells[3]   [4]    A M←A[5]    K←(⍳1↑⍴X)∘.,⍳1↓⍴Z←X⍝Index[6]    I←0[7]   L1:→(A<I←I+1)/0     ⍝For each cell to move,[8]    F←(1++/V≤(0, V[⍴V←+\(,Z)/,1-M]) UNIFORM 1)⊃Q←(,Z)⌿,K  ⍝   From, selected proportional to 1-score[9]    T←(?⍴Q)⊃Q←(,~Z)⌿,K ⍝   To[10]   Z[F[1];F[2]]←0 ⋄ Z[T[1];T[2]]←1[11]   →L1    ∇