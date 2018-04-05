﻿    ∇ Z←A GETLOCK P;R;R;P;T;M;Q;E;L;err;O[1]   ⍝Lock cluster run for thread/requestor, timeout, priority, and message ⍵, key ⍺ (default = pathA)[2]   ⍝This function "locks" a directory (or arbitrary key) using Edi's lock server[3]   ⍝(if lockserver=1) or old file-based LOCKDIR (if lockserver=0).[4]   ⍝Arguments:[5]   ⍝   ⍵[1] = thread       id of the current thread / requestor name (0 = use 'thread' if it exists, otherwise 0)[6]   ⍝   ⍵[2] = timeout      time in seconds beyond which it assumes a collision has occured and resets the locks[7]   ⍝                       if 0, than never reset; default = 3600 (1 hour)[8]   ⍝   ⍵[3] = priority     lock priority (default = 5)[9]   ⍝   ⍵[4] = message      message for lock server & log[10]  ⍝Globals:[11]  ⍝   pathA               default cluster path; used if not passed in ⍺[12]  ⍝   name                computer name[13]  ⍝   locktimeout         how long until a lock (not a project) times out? (default = 1800)[14]  ⍝   uselockserver       use lock server (default = 1)[15]  ⍝Result:[16]  ⍝   wait time           total wait time (seconds)[17]  ⍝   lockwait            add wait time to global variable lockwait[18]  ⍝B. Compton, 12 Feb 2013, from LOCKDIR and previous version of GETLOCK (11-16 Jan 2013)[19]  ⍝12 Mar 2013: include timeout[20]  ⍝6 May 2013: if unknown error from lock server, try reinitializing[21]  ⍝23 Jul 2013: wait lockpause sec to hopefully prevent file system collisions[22]  ⍝13 Aug 2013: if lock server times out, display a message and try again[23]  ⍝15 Nov 2013: thread of 0 defaults to thread if it's set; 15 Dec: do it right[24]  ⍝9 Dec 2013: exit if ~cluster[25]  ⍝13 Jan 2014: work if locktimeout doesn't exist yet[26]  ⍝17 Apr 2014: add wait time to global lockwait[27]  ⍝6 Jun 2016: 'clear Lock server timed out' message on recovery[28]  [29]  [30]  [31]   :if (0≠⎕NC 'cluster')              ⍝If cluster exists, exit if ~cluster[32]      →(~cluster)/Z←0[33]   :end[34]  [35]  [36]   ⍎(0=⎕NC'A')/'A←pathA'[37]   L←1800 ⋄ ⍎(0≠⎕NC'locktimeout')/'L←locktimeout'[38]   R T P M ← 4↑P,(⍴,P)↓0,L,5 ''               ⍝Requestor, timeout, priority, message[39]   ⍎((R≡0)^0≠⎕NC'thread')/'R←thread'          ⍝Default to current thread if thread = 0[40]   E←1                                        ⍝Reinitializaiton flag[41]   ⍎(0=⎕NC'uselockserver')/'uselockserver←1'[42]   →uselockserver/L1                          ⍝If uselockserver = 0,[43]   Z←A LOCKDIR R T                            ⍝   call old file-based locker[44]   →0                                         ⍝Else,[45]  [46]  L1:⍎((0≠⎕NC'computername')^0=1↑0⍴R)/'R←computername,''.'',⍕R'⍝   default requestor[47]   ⍎(0∊⍴M)/'M←1↓FIRSTCOL STRIP ⎕WSID'         ⍝   default message[48]   M←M,' (APL)'                               ⍝   append (APL) to message[49]  [50]   →(3=⎕NC'GETLOCKc')/L2                      ⍝   If not loaded,[51]   Q←⎕EX 'GETLOCKc'[52]   ⎕ERROR REPORTC 'DLL I4←LOCK_LIB.request_lock(*C1,*C1,*C1,I4,I4)' ⎕NA 'GETLOCKc'[53]  [54]  L2:Q←⎕AI[2][55]   O←0[56]  L3:⍝⎕←'[Locking ',A,' from ',R,'] - (',(FRDBL⍕FRDBL¨(¯1+(↓⎕SI)⍳¨'[')↑¨↓⎕SI),')' ⋄ FLUSH[57]   ⍝⎕←'[Locking ',A,' from ',R,', priority ',(⍕P),']' ⋄ FLUSH[58]   err←GETLOCKc ((FRDBL A) (⍕R) M,¨⎕TCNUL),P T⍝   get a lock from Edi's lock server[59]   :if err=3[60]      ⎕←'*** Lock server timed out (',NOW,'). Trying again...' ⋄ FLUSH[61]      O←1[62]      →L3[63]   :endif[64]  [65]   :if E^err=2                                ⍝   if unknown error,[66]      lockport LOCKINIT lockserver            ⍝      reinitialize[67]      E←0                                     ⍝      only do this once[68]      →L2[69]   :end[70]  [71]   ⎕ERROR REPORTC err[72]  [73]   :if O[74]      ⎕←'Lock server recovered (',NOW,').' ⋄ FLUSH[75]   :end[76]  [77]   T←⎕DL lockpause[78]   ⍎(0=⎕NC'lockwait')/'lockwait←0'[79]   lockwait←lockwait+Z←⎕AI[2]-Q               ⍝   return lock wait time and update global lockwait    ∇