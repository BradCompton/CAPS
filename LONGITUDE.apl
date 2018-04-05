﻿    ∇ Z←LONGITUDE;Q;X;Y;O;S;T[1]   ⍝Give longitude W (decimal degrees) for all cells in current regular tile or arbitrary block [2]   ⍝Globals:[3]   ⍝   origin = 1 latitude, northing, longitude, easting[4]   ⍝Conversion factors:[5]   ⍝   latitude: 90 degrees = 10,000,000 m (by definition)[6]   ⍝   longitude: 1 degree = 1852 m × cos(latitude) [1852 is 1 nautical mile][7]   ⍝Accurate to ≤1 km in Massachusetts...if using in other areas/projections, will need Method 2 from LATLONG.[8]   ⍝B. Compton 24 Mar 2015 (from LATLONG)[9]   ⍝4 May 2015: also work for regular tiles[10]  [11]  [12]  [13]   :if block[1]=¯1                                ⍝If arbitrary block,[14]      S←block[4 5]+2×block[6]                     ⍝   block = ¯1 r c rows cols buffer[15]   :else                                          ⍝Else, regular tile,[16]      S←((2×block[3])+block[1 2]×~T)+block[8 9]×T←block[4 5]=block[6 7]  ⍝   block = rows, cols, etc. (as in BLOCK)[17]   :end[18]   [19]   O←1 FINDPOINT S[1],1                           ⍝Origin point[20]   X←S⍴O[1]+cellsize×0,⍳S[2]-1[21]   Y←⍉(⌽S)⍴O[2]+cellsize×⌽0,⍳S[1]-1[22]  [23]   Q←origin[2]+(Y-origin[4])×90÷1E7               ⍝Latitude[24]   Z←|origin[3]-(X-origin[5])÷DEG 1852×2○RAD Q    ⍝longitude    ∇