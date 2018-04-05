﻿    ∇ Z←R NEWMVREP X;I;J;Q;err[1]   ⍝Replace missing values in 1⊃⍵ corresponding to 1s in binary 2⊃⍵ with ⍺ (default = MV)[2]   ⍝If ⍵ is a matrix, look for MVs in it[3]   ⍝Runs APL version if aplc=1, or C version if aplc=2[4]   ⍝B. Compton/E. Ene, 19 Dec 2008[5]   ⍝17 Feb 2010: return integer for integer argument[6]   ⍝8 Oct 2010: separate floating point and integer versions[7]   ⍝27 Aug 2012: make sure MV grid is integer but do it quickly[8]   ⍝20 Sep 2012: new version from Edi takes binary template[9]   [10]  [11]  [12]   ⍎(0=⎕NC'R')/'R←MV'[13]   ⍎(2>≡X)/'X←X (X=MV)'           ⍝If passed only 1 matrix, template is X=MV[14]   ⎕ERROR (~≡/⍴¨X)/'MVREP: matrices with different shapes'[15]   →(aplc=1)/L2                   ⍝If C version,[16]   →(3=⎕NC'MVREPc')/L1            ⍝   If not loaded,[17]   Q←⎕EX 'MVREPc'[18]   ⎕ERROR REPORTC 'DLL I4← CAPS_LIB.mvrep_dbl(I4,I4,F8,F8,*F8←,*B1)' ⎕NA 'MVREPc'[19]   ⎕ERROR REPORTC 'DLL I4← CAPS_LIB.mvrep_int(I4,I4,I4,I4,*I4←,*B1)' ⎕NA 'MVREP_Ic'[20]  ⍝⎕←'CAPS_LIB.mvrep loaded.'[21]  [22]  L1:X Z←X[23]   I J ← ¯2↑1 1,⍴X[24]   →(645∊⎕DR¨X R)/L3              ⍝If matrix and replacement are integers,[25]   err Z←MVREP_Ic I J MV R X Z[26]   →L4[27]  [28]  L3:→(323=⎕DR Z)/L5              ⍝If missing value grid is floating point, change it to integer[29]  L5:err Z←MVREPc I J MV R X Z    ⍝Else, floating point version[30]  L4:⎕ERROR REPORTC err[31]   →0[32]  [33]  L2:Z X←X                        ⍝Else, APL version[34]   Z←R UNMV X REMV Z    ∇