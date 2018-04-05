﻿    ∇ Z←P STRAIGHT X;H;A;D;E[1]   ⍝Return 1 if points ⍵[;⍳2] fall in a straight line, within tolerance ⍺ (max percent deviation from line)[2]   ⍝B. Compton, 13 Aug 2015[3]   [4]   [5]   [6]    ⍎(0=⎕NC'P')/'P←5'                              ⍝Default tolerance: 5%[7]    →(Z←2=(⍴X)[1])/0                               ⍝If line has only two points, it's certainly straight[8]    H←(+/(((¯2 0+⍴X)⍴X[1;])-¯1 0↓1 0↓X)*2)*.5      ⍝Hypotenuses from home to each point[9]    A←RAD ANGLE¨(⊂X[(1↑⍴X),1;])⍪¨↓¯1 0↓1 0↓X       ⍝Angle from home to each point (in radians)[10]   D←H×1○A                                        ⍝Deviation from each point to line from home to end[11]   E←100×(⌈/D)÷(+/(X[1;]-X[(⍴X)[1];])*2)*.5       ⍝Max percent deviation over length of line[12]   Z←E≤P                                          ⍝Return 1 if line is pretty straight        ∇