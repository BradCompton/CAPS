﻿    ∇ A LOCKWRITE F;P;T;L[1]   ⍝Append vector or matrix ⍺ to text file ⍵ (optional delimiter 2⊃⍵); lock file if running on cluster[2]   ⍝B. Compton, 21 May 2010, pulled from MOVEPOOLS[3]   ⍝24 May 2011: use Anthill lock mechanism[4]   ⍝19 Apr 2012: use 5 minute timeout in case a writing thread gets KILLed; 9 Jan 2014: drop timeout[5]   ⍝5 Jun 2012: don't bother if empty input[6]   ⍝27 Sep 2012: unlock directory if there's an error[7]   ⍝28 Feb 2013: when setting ⎕ELX, clear RETURNLOCK so it only gets called once[8]   ⍝28 Feb 2013: don't confuzzle delimiter with key[9]   ⍝3 Mar 2013: wait 1/10 sec after writing to give OS time to release the file (experimental)[10]  ⍝31 Dec 2013: don't need to set thread; this now happens in GETLOCK[11]  ⍝3 Jan 2014: use LOCKFILE/UNLOCKFILE[12]  [13]  [14]  [15]   →(0∊⍴A)/0[16]   →cluster/L1                                ⍝Write new to result table (single machine version)[17]   A TMATAPPEND F[18]   →0[19]  [20]  L1:P←F ⋄ ⍎(2≤≡F)/'P←1⊃F'[21]   L←LOCKFILE (1+-(⌽P)⍳'\')↓P                 ⍝Cluster version - lock file while writing[22]   A TMATAPPEND F[23]   T←⎕DL .1                                   ⍝Give OS a little time to release file[24]   UNLOCKFILE L    ∇