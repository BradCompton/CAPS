﻿    ∇ Z←SUBSIZE P[1]   ⍝Give size of directory ⍵[2]   ⍝B. Compton, 28 Jan 2015[3]   [4]   [5]   [6]    Z←(FILEINFO P)[1][7]    Z←Z++/SUBSIZE¨(⊂P),¨0 SUBDIRS P    ∇