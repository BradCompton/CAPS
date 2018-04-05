﻿    ∇ A CULVERTS S;T;buffer;head;B;A;Q;R;D;I;Z;W;result;streams;R;S;M[1]   ⍝Find culverts at points where centerlines cross roads and railroads[2]   ⍝Runs as CAPS metric[3]   ⍝Inputs:[4]   ⍝   source\roadslines.txt       road segments, from makeroads.aml[5]   ⍝   source\trainslines.txt      train segments, ditto[6]   ⍝   source\streamlines.txt      stream centerline segments, from makestreams.aml (parameter 'streams')[7]   ⍝Result:[8]   ⍝   source\culvertpts.txt       x,ys of stream crossings (parameter 'result')[9]   ⍝B. Compton, 20 Jul 2010[10]  ⍝5 Aug 2010: keep some road attributes[11]  ⍝12 Aug 2010: speed-up by a factor of > 100× ![12]  ⍝18 Jan 2010: Use parameters for streams and result, so this can be used for coaststreams for tidal restrictions[13]  ⍝22 Dec 2011: only need 1st 4 elements of roads and trains tables[14]  ⍝22 Nov 2013: don't keep vector data in memory--it leads to inter-run interactions in Anthill![15]  ⍝31 Dec 2013: use READVEC and drop clipping to windows[16]  ⍝22-24 Jan 2014: drop buffer argument, as readvec will get all lines that fall even partly within tile + set up block; allow empty roads table[17]  ⍝30 Jan 2014: remove duplicates[18]  ⍝4 Feb 2014: buffer around each stream segment dynamically, based on longest road segment[19]  [20]  [21]  [22]   READPARS ME[23]   SETTILE                                                ⍝Set up to get tile boundary for READVEC[24]   buffer←4⊃A[25]   ⍞←'Reading vector data...' ⋄ FLUSH[26]   T←1⊃READVEC pathS,'roadlines.txt'                      ⍝Roads (x,y,x,y,class,inventory,traffic)[27]   R←(((1↑⍴T),4)↑T)⍪(1⊃READVEC pathS,'trainlines.txt')[;⍳4]       ⍝Trains[28]   S←1⊃READVEC pathS,streams                              ⍝Streams[29]   ⎕←'done' ⋄ FLUSH[30]   →((0∊⍴R)∨0∊⍴S)/0                                       ⍝If no roads or no streams in block, there are no culverts[31]   Q←THISBLOCK[32]   W←(¯1 1 ¯1 1×cellsize÷2)+(FINDPOINT (+/Q[1 3]),Q[2]),FINDPOINT Q[1],+/Q[2 4]  ⍝Window for this block (adjust for half cell)[33]   M←⌈/(+/(R[;1 2]-R[;3 4])*2)*.5                         ⍝Max road segment length - use this to buffer window around each stream segment[34]  [35]   Z←(0,¯2+1↓⍴R)⍴0[36]   I←0[37]  L1:→((1↑⍴S)<I←I+1)/L2                                                       ⍝For each stream segment,[38]   ⍎((I÷100)=⌊I÷100)/'BREAKCHECK'                                             ⍝   Check for break every 100 segments[39]   D←((⌊/S[I;1 3]),(⌊/S[I;2 4]),(⌈/S[I;1 3]),⌈/S[I;2 4])+¯1 ¯1 1 1×M          ⍝   Window for this segment[40]   Q←(R[;1]≥D[1])^(R[;1]≤D[3])^(R[;2]≥D[2])^R[;2]≤D[4]                        ⍝   Roads in this window[41]   Q←(Q∨(R[;3]≥D[1])^(R[;3]≤D[3])^(R[;4]≥D[2])^R[;4]≤D[4])⌿R[42]   Z←Z⍪(2 2⍴S[I;]) CROSSPOINT Q                                               ⍝   Find crossings[43]   →L1[44]  [45]  L2:Z←((Z[;1]≥W[1])^(Z[;1]≤W[3])^(Z[;2]≥W[2])^Z[;2]≤W[4])⌿Z  ⍝Clip to actual window[46]   Z←Z[⍋Z;][47]   Z←(∨/Z≠¯1 0↓0⍪Z)⌿Z                                     ⍝Remove duplicates - these happen when road breaks exactly on stream[48]   →(0∊⍴Z)/0[49]   Z LOCKWRITE pathS PATH result[50]   →0[51]  [52]  [53]  what:data prep[54]  type:standard[55]  info:('') ('') ('') 0 'luwet'           ⍝Source grids, settings table, result grid, and buffer size[56]  check:CHECKVAR 'streams result'[57]  init:head←1↓⎕TCHT MTOV MATRIFY 'x-coord y-coord' ⋄ (0 0⍴'') TMATOUT pathS PATH result ⍝(Re)create points file on start    ∇