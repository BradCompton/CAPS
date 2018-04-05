﻿    ∇ A GRIDINIT S;P;port;M;O;W;C;E;D[1]   ⍝Initialize grid server on server and port ⍵, add = ⍺[2]   ⍝   ⍵[1]    server ('' for local grid server)[3]   ⍝   ⍵[2]    port (not needed for local server)[4]   ⍝   ⍵[3]    drive (optional)[5]   ⍝   ⍺       add - if 1, add to connection list; if 0, replace all connections[6]   ⍝B. Compton, 9-12 Sep 2013[7]   ⍝4 Oct 2013: add optional drive[8]   [9]   [10]  [11]   ⍎(0=⎕NC'A')/'A←0'              ⍝Default is ADD = false[12]   ⍎(0=⍴S)/'S←S 0'[13]   S P D ← 3↑S,0 0                ⍝Server, port, and drive[14]   ⍎(D≡0)/'D←'''''[15]   M←1+0=⍴S                       ⍝Mode: 1 for remote, 2 for local[16]   :if ~A                         ⍝If add = false,[17]      CLEANUP                     ⍝   reset everything[18]   :end[19]   INITCONNECTIONS                ⍝create connection variables if they don't exist[20]   O←activeconnection             ⍝save activeconnection in case of errors[21]   ∆GRIDINIT S P serverlog        ⍝Initialize grid server[22]   :if M=1                        ⍝If remote,[23]      W←¯1↓GETWINDOW              ⍝   query server for current grid window; drop blockonly element[24]      W←W (0≠⍴W)                  ⍝   2nd element is 1 if window is set[25]   :else                          ⍝else, local,[26]      W←(⍳0) 0                    ⍝   window is not set[27]   :end[28]   C←(2⊃W),W[1],(M=2),(⊂S),P,serverlog,0,⊂D  ⍝New connection[29]   :if ~A                         ⍝If add is false,[30]      connections←(1,⍴C)⍴C        ⍝   add, replacing all connections with this one[31]      activeconnection[1]←1[32]   :else                          ⍝else, add is true,[33]      :if ~1⊃E←CHECKWINDOW W      ⍝   if the window is bad,[34]         SETCONNECTION O[1]       ⍝      set back to the old connection[35]         SETCACHE O[2][36]         ACTIVATECONNECTION       ⍝      and reactivate it[37]         activeconnection←O[1]    ⍝      in case there is something pending[38]         ⎕ERROR 'Error: new connection can''t be added - ',2⊃E[39]      :end[40]      connections←connections⍪C   ⍝   add new connection[41]      activeconnection[1]←1↑⍴connections[42]   :end[43]   :if (0=⍴referencewindow)^0≠⍴1⊃W⍝If no reference window but this window is defined,[44]      referencewindow←5↑1⊃W[45]      workingresolution←(1⊃W)[5][46]   :end[47]   activeconnection[2]←0          ⍝Always turn caching off    ∇