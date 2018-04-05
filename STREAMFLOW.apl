﻿    ∇ A STREAMFLOW S;X;C;V;D;R;Q;reach;I;G;N;buffer;M;F;B;E;Y;transparent;streamlines;L[1]   ⍝Burn vector streams into a DEM-derived flow grid[2]   ⍝Implemented as a CAPS metric[3]   ⍝Must run getstreams.aml first to prepare vector data (it should be in source\streamlines.txt), then run DEBOG[4]   ⍝(on a single machine) to edit out excess channels in cranberry bogs and salt marshes.[5]   ⍝Vector data is loaded once and kept in workspace; use CLEAR to delete it.[6]   ⍝Source data:[7]   ⍝   source\rawflow          Raw D8 flow grid from Arc[8]   ⍝   source\streamlines.txt  Vector streams[9]   ⍝Results:[10]  ⍝   source\flow             D8 flow grid with burned streams[11]  ⍝   source\flowchange       Marks stream centerlines and where changes were made[12]  ⍝   results\flowloops       Marks loop errors[13]  ⍝Parameters:[14]  ⍝   streamlines Name of vector streams text file (usually 'streamlines.txt')[15]  ⍝   burn       If yes, burn streams and then check, otherwise just check previously burned streams (*** Before[16]  ⍝              running with burn = no, you must copy FLOW and FLOWCHANGE to grids\ ***)[17]  ⍝   reach      Distance beyond block edge to include stream segment endpoints (m)[18]  ⍝              note: we already have streams with either endpoint in block; this covers streams that have neither[19]  ⍝              endpoint in block (but nearby)[20]  ⍝   interval   Point interval (high density = orthogonal corners, low density = diagonals).  Should not be larger[21]  ⍝              than cell size; must be infintesimal to always give orthogonal corners (not necessary, I think)[22]  ⍝   buffer     Edge buffer to catch large loops.  Use 2000 m or so.[23]  ⍝[24]  ⍝Returns (1) flow, the new flow grid, (2) flowchange, a grid marking where changes were made, and (3) flowloops, a[25]  ⍝grid marking loop errors.[26]  ⍝   flowchange represents the results of flow-burning process. It has the following values:[27]  ⍝      0       off-centerline (all values ≥1 represent stream centerlines without orthogonal corners)[28]  ⍝      1       cell visited (but flow not changed)[29]  ⍝      2       cell changed[30]  ⍝      ≥3      cell was changed after a visit, or changed multiple times.  This represents a loop, usually a tight[31]  ⍝              stream loop (flow out of cell then immediately back in), which isn't an error.  But it's worth having a[32]  ⍝              look; there may be real errors here.[33]  ⍝   flowloops marks cells where loop errors were found. It has the following values:[34]  ⍝      ≥1      for all cells that are part of a flow loop[35]  ⍝      ≥2      for likely culprits[36]  ⍝      It's best to convert flowloops to a point coverage to evaluate errors.  In Arc/grid,[37]  ⍝         errors = gridpoint(setnull(flowloops == 0, flowloops), value)[38]  ⍝      Then highlight errors = 1 in blue, and errors≥2 in red.  Blue points are loops, and red points are likely[39]  ⍝      causes.[40]  ⍝[41]  ⍝Find breaks in streamlines (these are always errors) by calculating flow accumulation, and highlighting cells > all[42]  ⍝neighbors.  Those not on edge of landscape/ocean are errors.[43]  ⍝[44]  ⍝NOTE: flowchange also supplies gridded stream centerlines.  Orthogonal neighbors are NOT guaranteed, but this version[45]  ⍝actually aligns with flow.[46]  ⍝[47]  ⍝NOTE: to run for just a particular watershed, set mask to watershed's mask in inputs.par[48]  ⍝[49]  ⍝WARNING: ESRI's grid I/O software often writes damaged VATs, so use Grid: BUILDVAT on flowchange and flowloops before[50]  ⍝assuming all is well.[51]  ⍝[52]  ⍝B. Compton, 8-9, 14 Jul 2010, from MOVEPOOLS[53]  ⍝5 Aug 2010: calls FIXLOOPS to fix most errors[54]  ⍝6 Aug 2010: fix ugly buffer bug.  Aug 7: Fix it the rest of the way.[55]  ⍝9 Aug 2010: look for loops beyond streamlines; burn option; dumb-ass bug[56]  ⍝17 Jan 2013: correct and improve comments[57]  ⍝19-20 Aug 2013: Use mask, write transparently, and don't delete result grids on run so we can do this by HUC 4 watersheds; name of streamlines is a parameter[58]  ⍝26 Aug 2013: use results.par to redirect results, despite being pulled out of info; minor oops on file read[59]  ⍝13 Sep 2013: use rawflow as the include grid, so we actually run for all flow cells, regardless of luwet[60]  ⍝21 Nov 2013: give error if no streams for current tile; 21 Nov, no, just log warning[61]  ⍝21 Nov 2013: oh, shit. Can't save vector streamlines in the workspace![62]  [63]  [64]  [65]   READPARS ME[66]   buffer←4⊃A[67]   A[3]←⊂(pathS PATH 'flow') (pathS PATH 'flowchange') 'flowloops'  ⍝Not set in info because we don't want to kill existing grids[68]   →burn/L0                                               ⍝If checking but not burning,[69]   X←READ pathG PATH 1⊃3⊃A                                ⍝Read result grid[70]   →(0∊⍴Y←'*' '' INCLUDE (⍴X)⍴1)/0                        ⍝Which cells to run for?  (not using landcover, so pass it all 1s)[71]   M←READ pathG PATH 2⊃3⊃A                                ⍝and change grid[72]   →(^/,X=MV)/0[73]   →L3[74]  [75]  L0:⍞←'Reading vector data...' ⋄ FLUSH[76]   L←MATIN pathS PATH streamlines[77]   ⎕←'done' ⋄ FLUSH[78]  [79]  L1:X←READ pathG PATH 1⊃A                                ⍝Read flow grid[80]   →(^/,X=MV)/0                                           ⍝If no flow data, bail out[81]   →(0∊⍴Y←'*' '' INCLUDE (⍴X)⍴1)/0                        ⍝Which cells to run for?  (not using landcover, so pass it all 1s)[82]  [83]   C←(1 ¯1×cellsize÷2)+FINDPOINT (block[1 2]×block[4 5]-1)-block[3]  ⍝Upper left corner of block in map coordinates[84]   C←C,C+cellsize×1 ¯1×(⌽⍴X)                              ⍝and lower right corner[85]   D←C+¯1 1 1 ¯1×reach                                    ⍝Expand block by reach (= longest stream vector)[86]   Q←(L[;1]≥D[1])^(L[;1]≤D[3])^(L[;2]≥D[4])^L[;2]≤D[2]    ⍝streams in block[87]   R←(Q∨(L[;3]≥D[1])^(L[;3]≤D[3])^(L[;4]≥D[4])^L[;4]≤D[2])⌿L[88]  [89]   M←(⍴X)⍴0                                               ⍝Flag visited (=1), modified (=2), and error (≥3) cells[90]   :if 0∊⍴R[91]      LOG 'STREAMFLOW warning: there are no streams for tile ',(⍕block[4]),',',(⍕block[5]),' of ',(⍕block[6]),',',(⍕block[7]),'.'[92]      →L3[93]   :end[94]  [95]   D←(MV,2⍴0)⍪(2*¯1+⍳8),8 2⍴0 1 1 1 1 0 1 ¯1 0 ¯1 ¯1 ¯1 ¯1 0 ¯1 1   ⍝Translation: flow directions to cell orientation[96]  [97]   I←0[98]  L2:→((1↑⍴R)<I←I+1)/L3                                   ⍝For each stream segment,[99]   BREAKCHECK[100]  V←R[I;1 2]⍪((((⌊N),2)⍴R[I;1 2])-(⍳⌊N)∘.×(-⌿2 2⍴R[I;])÷N←((+/(-⌿2 2⍴R[I;])*2)*.5)÷interval)⍪R[I;3 4]    ⍝   points along segment[101]  C←(↑FINDCELL¨↓V)-¯1+((1↑⍴V),2)⍴THISBLOCK[1 2]-buffer   ⍝   Cells these points fall within, in order[102]  C←(∨/C≠1 0↓C⍪0)⌿C                                      ⍝   Drop duplicates[103]  C←(^/((C≥1)^C≤(⍴C)⍴⍴X))⌿C                              ⍝   Not outside of block, but do need to correct within buffer[104]  →(0∊⍴C)/L2                                             ⍝   bail if nothing[105]  →(^/MV=X SCATI C)/L2                                   ⍝   or all missing[106] [107]  F←X SCATI C                                            ⍝   Existing flow direction for each cell[108]  F←(B←(¯1↓F≠MV),0)/F                                    ⍝   Ignore flows through missing data, and also drop last cell[109]  G←B⌿(1 0↓C⍪0)-C                                        ⍝   Correct flow directions for each cell[110]  C←B⌿C[111]  Q←∨/D[D[;1]⍳F;2 3]≠G                                   ⍝   Cells to change[112]  →(~1∊Q)/L4                                             ⍝   If any changes,[113]  M←M SCATR (Q⌿C) (2+M SCATI Q⌿C)                        ⍝      Track changes: +2 if changing cell[114]  X←X SCATR (Q⌿C) (D[(↓D[;2 3])⍳↓Q⌿G;1])                 ⍝      Change cells in flow grid[115] L4:M←M SCATR C (1⌈M SCATI C)                            ⍝   Record ⌈1 for cells that we've now visited[116]  →L2[117] [118] L3:X E ← X FIXLOOPS M                                   ⍝Look for loops in flow grid[119]  transparent←1                                          ⍝Write results transparently so we don't nuke neighboring watersheds[120]  (MVREP X (~Y)) WRITEI pathR SUBNAMER 1⊃3⊃A             ⍝Write result grid[121]  (MVREP M (~Y)) WRITEI pathR SUBNAMER 2⊃3⊃A             ⍝and change grid[122]  (MVREP E (~Y)) WRITEI pathR SUBNAMER 3⊃3⊃A             ⍝and loop grid (2 = fixed errors, 3 = remaining errors)[123]  Q←+/3≤,(2⍴buffer)↓(-2⍴buffer)↓E[124]  LOG '[',(⍕block[4 5]),'] ',(⍕Q),' loop errors remaining in block ',(⍕(4↑block)[4]),',',⍕(5↑block)[5][125]  →0[126] [127] what:data prep[128] type:standard[129] ⍝i⍝nfo:(pathS PATH 'rawflow') ('') ((pathS PATH 'flow') (pathS PATH 'flowchange') 'flowloops') (⌈buffer÷cellsize) 'luwet'       ⍝Source grids, settings table, result grid, buffer size, and include grid[130] info:(pathS PATH 'rawflow') ('') ('') (⌈buffer÷cellsize) (pathS PATH 'rawflow')        ⍝Source grids, settings table, result grid, buffer size, and include grid[131] check:CHECKVAR 'reach interval burn streamlines'    ∇