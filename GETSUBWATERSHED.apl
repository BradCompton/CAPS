﻿    ∇ Z←GETSUBWATERSHED I;B;S;W;T;H[1]   ⍝See if there's a subwatershed at cell ⍵; if so, return intermediate values, else return ⍳0[2]   ⍝Relies on model\subwatersheds.txt, written by WATERSHED[3]   ⍝Global:[4]   ⍝   subw    list of potential subwatersheds for this watershed[5]   ⍝B. Compton, 18 and 21 May 2012[6]   [7]   [8]   [9]    Z←⍳0[10]   →(0∊⍴subw)/0                                               ⍝If any potential subwatersheds,[11]   →(~1∊B←subw[;2 3]^.=I)/0                                   ⍝   And if we're at outflow cell of one,[12]  L1:S←MATIN pathI PATH 'subwatersheds.txt'[13]   →((S≡1 1⍴MV)∨0∊⍴S)/L2                                      ⍝   If there's anything in subwatershed file,[14]   H←(↓S[;2 3])⍳⊂(,B⌿subw)[4 5]                               ⍝      look up our subwatershed[15]   →(H≤1↑⍴S)/L5                                               ⍝      If it's not there,[16]  [17]  L2:LOG 'Waiting on results for subwatershed #',(⍕(,B⌿subw)[1]),'...'     ⍝         We'll have to wait for another thread to finish it[18]   W←⎕AI[2][19]  L3:→(~(⌊(⎕AI[2]-W)÷60)∊2 10 60 120 240 480 960 1440 2880)/L4⍝   Chatter at these minute marks[20]   LOG 'Have been waiting on results for subwatershed #',(⍕(,B⌿subw)[1]),' for ',(TIME ⎕AI[2]-W),' (h:m:s)...'[21]  L4:T←⎕DL 62                                                 ⍝   Wait just over a minute (to prevent multiple chatters per mark)[22]   S←MATIN pathI PATH 'subwatersheds.txt'                     ⍝   Try again[23]   →((S≡1 1⍴MV)∨0∊⍴S)/L3                                      ⍝   If there's anything in subwatershed file,[24]   H←(↓S[;2 3])⍳⊂(,B⌿subw)[4 5]                               ⍝      look up our subwatershed[25]   →(H>1↑⍴S)/L3                                               ⍝      If it's there,[26]   LOG 'Got results for subwatershed #',⍕(,B⌿subw)[1][27]  L5:Z←S[H;]                                                  ⍝      Return intermediate results for subwatershed    ∇