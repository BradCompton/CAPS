﻿    ∇ TOBYGRID;G;S;O;E;N;Z;L;head[1]   ⍝Make grid of sample points for Mount Toby[2]   ⍝B. Compton, 16 Sep 2010[3]   [4]   [5]    G←16 11                    ⍝Grid size[6]    S←200                      ⍝Grid spacing[7]    O←114059 913678            ⍝Origin (E, N of southwest corner)[8]   [9]    E←,O[1]+G⍴S×¯1+⍳G[2]       ⍝Easting[10]   N←,O[2]+⍉(⌽G)⍴S×¯1+⍳G[1]   ⍝Northing[11]   L←(,G⍴'ABCDEFGHIJKLMNOPQRSTUVWXYZ'[⍳G[2]]),LJUST⍕((×/G),1)⍴⍉⌽(⌽G)⍴⍳G[1][12]  [13]   Z←E,N,[1.5]FRDBL¨↓L[14]   Z←Z,0 2↓Z[;1 2] SAMPLEGRID 'd:\caps\source\ dem slope aspect'[15]   head←'x-coord,y-coord,label,elevation,slope,aspect'[16]   ⍞←(⍕×/G),' total points written to '[17]   Z CMATOUT ⎕←'d:\caps\project\tobygrid.txt'    ∇