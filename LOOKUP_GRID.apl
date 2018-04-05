﻿    ∇ Z←D LOOKUP_GRID G;D_;I;B;C[1]   ⍝Look up grid ⍵ in cache directory & columns ⍺[2]   ⍝Find last 'ready' grid, if there is one; otherwise find last 'copying' grid (or return 0 if nothing)[3]   ⍝B. Compton, 26 Apr 2017[4]   [5]   [6]   [7]    D D_ ← D[8]    I←D[;D_ COL 'source'] FINDI G[9]    B←D[I;D_ COL 'status']≡¨⊂'ready'[10]   C←D[I;D_ COL 'status']≡¨⊂'copying'[11]   :if 1∊B            ⍝If any are ready,[12]      Z←¯1↑B/I        ⍝   take last one[13]   :elseif 1∊C        ⍝Else, if any are copying,[14]      Z←¯1↑C/I        ⍝   take last one[15]   :else              ⍝Else,[16]      Z←0             ⍝   grid not found[17]   :end    ∇