﻿    ∇ A GRIDCOPY B;Q[1]   ⍝Copy grid or mosaic ⍺ to grid or mosaic ⍵[2]   ⍝B. Compton, 18 Feb 2009; E. Ene, 6 Feb 2009[3]   ⍝2 May 2011: set global gridwait for task manager[4]   ⍝5 Nov 2013: copy mosaics too[5]   ⍝13 Nov 2013: add grid server recovery[6]   ⍝26 Nov 2013: split from ∆GRIDCOPY[7]   ⍝17 Dec 2013: ignore non-mosaic/non-grids[8]   [9]   [10]  [11]   Q←GRIDDESCRIBE A←FRDBL A               ⍝What is it?[12]   →(0∊⍴Q)/0                              ⍝If it's neither a mosaic nor a grid, it's not our problem[13]   :if Q[12]                              ⍝If it's a mosaic,[14]      (A,'\') COPYDIRSUB (FRDBL B),'\'    ⍝   copy it[15]   :else                                  ⍝Else, treat it as a grid[16]      A ∆GRIDCOPY B[17]   :end    ∇