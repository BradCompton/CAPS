﻿    ∇ Z←GETWHAT F;T;Q[1]   ⍝Reads what kind of metric function ⍵ is[2]   ⍝Each metric must have a label 'info' with one of the following:[3]   ⍝   CAPS stressor       stressor metric, part of CAPS core[4]   ⍝   CAPS resiliency     resiliency metric, part of CAPS core[5]   ⍝   CAPS watershed      watershed metric, part of CAPS core[6]   ⍝   CAPS coastal        coastal metric, part of CAPS core[7]   ⍝   data prep           metric for preparing CAPS data[8]   ⍝   other               some sort of auxiliary metric[9]   ⍝   auxiliary           post-processing[10]  ⍝   junk[11]  ⍝The what facility is used by LISTGRIDS, for documentation purposes[12]  ⍝B. Compton, 12 Jan 2012[13]  [14]  [15]   T←(Q←(∨\T ⎕SS 'what',':')/T←⎕VR TOUPPER F)⍳⎕TCNL[16]   →(0∊⍴Z←Q)/0[17]   Z←¯1↓5↓T↑Q    ∇