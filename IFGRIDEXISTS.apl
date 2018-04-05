﻿    ∇ Z←IFGRIDEXISTS G[1]   ⍝Return 1 if grid (or mosaic) ⍵ exists[2]   ⍝B. Compton, 11-13 Dec 2013[3]   ⍝13 Jan 2014: pass through empty grid names quickly[4]   [5]   [6]   [7]    →(0∊⍴FRDBL G)/Z←0[8]    Z←0≠⍴0 1 GRIDDESCRIBE G    ⍝A solid but slow approach--checking for files circumvents locking and gives wrong answers sometimes    ∇