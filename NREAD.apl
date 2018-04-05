﻿    ∇ Z←NREAD F;N;I;T[1]   ⍝Read and return dos file ⍵[2]   ⍝11 Apr 2011: tie in non-exclusive mode[3]   ⍝2 May 2011: try again a few times if error[4]   ⍝22 Jul 2011: Report file not found errors politely; attempt to read Unix files properly[5]   [6]   [7]   [8]    I←0[9]   L1:T←⎕DL ¯1+2*¯1+I←I+1[10]  [11]  :Try[12]   F ⎕XNTIE (N←-1+0⌈⌈/|⎕XNNUMS),64 ⍝If file exists,[13]   Z←⎕NREAD N,82,⎕NSIZE N                             ⍝   return contents[14]   ⎕NUNTIE N[15]  [16]  :CatchIf 1∊⎕DM ⎕SS 'The system cannot find the file specified'[17]   ⎕ERROR 'Error: file not found: ',F[18]  [19]  :CatchIf 1∊⎕DM ⎕SS 'The system cannot find the path specified'[20]   ⎕ERROR 'Error: file path not found: ',F[21]  [22]  [23]  :CatchAll[24]   ⍎(0=⎕NC'tries')/'tries←1'[25]   →(I<tries)/L1                                      ⍝Try again tries times[26]   ⎕ERROR ⎕DM[27]  [28]  :EndTry[29]   Z←((^/Z≠⎕TCNL)/'.',⎕TCLF,'.',⎕TCNL) TEXTREPL Z     ⍝If no newlines, might be in Unix format, so convert linefeeds to newlines[30]   Z←(Z≠⎕TCLF)/Z                                      ⍝Strip linefeeds[31]   Z←(^\Z≠'→')/Z                                      ⍝Strip after EOF[32]   Z←(-+/^\⌽Z=⎕TCNL)↓Z                                ⍝Strip trailing newlines[33]   Z←(Z≠⎕AV[1])/Z                                     ⍝Strip nulls    ∇