﻿    ∇ Z←GETPATHS;K;L;T[1]   ⍝Return list of current paths[2]   ⍝B. Compton, 8 Feb 2011, from SHOWPATHS[3]   [4]   [5]    SETPATHS[6]    K←MATRIFY 'model metrics run grids results working software post deltas source tables rawsettings mixedsettings FTP'[7]    L←MATRIFY 'pathI pathM pathP pathG pathR pathW pathA pathE pathD pathS pathT pathU pathN pathF'[8]    Z←(↓L),(↓K),[1.5]⍎¨↓L       ⍝Show paths (whether or not they exist)    ∇