﻿    ∇ A AQCONNECT S;X;J;I;R;Z;K;L;D;G;E;B;V;Y;buffer;head;crossings;crossscores;transparent;T;M;F;C;O;T1;T2;E1;O1;P;fd;X2;S2;Q;sr;srt;sd;sdt;Y2;masktocore;N;downstream;correct;raw;t;watershed;XX;v3;Z2;benchmark[1]   ⍝CAPS 3.0 aquatic connectedness metric for groups ⍵[2]   ⍝⍺ = (landcover grid) (settings) (result grid) (buffer)[3]   ⍝Parameters:[4]   ⍝   multiplier      multiplier on contrast to get resistance[5]   ⍝   bandwidth       bandwidth (h) in m[6]   ⍝   search          search distance in s.d.[7]   ⍝   resist          resistance value by cover type[8]   ⍝   density         build kernels every nth cell (use density = 1 for normal, slower results)[9]   ⍝   masktocore      clip results to core mask[10]  ⍝   v3              if yes, do Gaussian scaling wrong to match pre-30 Jan 2018 runs[11]  ⍝Note: we don't use diagonals in WETSPREAD, because it gives goofy results...diagonal distances are farther, but we're also building kernels[12]  ⍝at a lower density, so treating all steps as 1 gives consistent results.[13]  ⍝Another note: mask is ignored for this metric, because we need to run for cells outside of mask to get kernel values[14]  ⍝B. Compton, 24 Jan 2011, from CONNECT[15]  ⍝Note: result grids are all <grid>0, because they need MIXWATER/MIXLAKES to finish them off[16]  ⍝4 Feb 2011: Oops...only run for stream centerline cells[17]  ⍝16 Feb 2011: adjust for edge effects in aqisolate and aqconduct, from CONNECT[18]  ⍝18 Feb 2011: Always set anthro settings to zero for focal cell[19]  ⍝1 Mar 2011: Result is 0 for off-centerlines[20]  ⍝26 May 2011: Drop old aqconnect and aqconduct; this is new aquatic connectedness (formerly known as isolation).  Old version is in AQCONNECT_3[21]  ⍝20-25 Jul 2011: modifications for new version of LINKAGES[22]  ⍝4-5 Aug 2011: standardize across values of search (results ~= old version with search = 3); restrict to circle with radius = search[23]  ⍝              Note: Unlike in connectedness, results vary slightly with varying search distance, because only centerlines, not all cells, are included[24]  ⍝16 Aug 2011: Drop call to LINKEXAMPLE - it's handled in LINKAGES[25]  ⍝12-22 Sep 2011: Follow flow grid using WETSPREAD[26]  ⍝23 Sep 2011: Edge correction must use landcover with all values, not streams only![27]  ⍝28-29 Sep 2011: Edge correction needs to include cells in buffer; only do it for stream cells[28]  ⍝27 Oct 2011: 2 sets of weights for settings variables and other changes for new SETTINGS; 6 Nov minor oops[29]  ⍝9 Nov 2011: oops...return MV for off-centerlines--otherwise 0s are brought into mixwater. 17 Nov 2011: get it right[30]  ⍝10 Feb 2012: work properly with clipped landscapes: use includefull, and skip unnecessary edge correction in buffer; ignore mask[31]  ⍝30 Apr 2012: Add denisty option to do sparse runs[32]  ⍝2 May 2012: multiply result by scalefactor to get results that approach 1.0 (see scale.aqconnect.r)[33]  ⍝15 Aug 2012: bug in edge correction if window was all MV[34]  ⍝16 Aug 2012: thanks to maskbits, go back to using mask, and use regular include, dropping includefull (undo changes from 10 Feb 2012)[35]  ⍝21 Aug 2012: prevent tile boundary artifacts caused by density not being a factor of tile size[36]  ⍝29 Nov 2012: if called from linkages or findpaths, READPARS is done by calling function; unlocalize parameters[37]  ⍝20 May 2013: add correct: if correct = no, don't do edge correction (for CSB)[38]  ⍝30 May 2013: clip results to core mask if masktocore = yes, as in CONNECT; 7 Jun 2013: do it properly[39]  ⍝20 Jun 2013: add downstream option.  If yes, flow up only to get downstream connectivity.  For Yoichiro.[40]  ⍝3 Jan 2014: use GRIDNAME on READBLOCK; 15 Jan: do it right[41]  ⍝1 Apr 2014: turn off density when example is set[42]  ⍝30 Jan 2018: scale by full kernel, not just streams [43]  ⍝1 Feb 2018: add v3 option, to revert to old, wrong Gaussian scaling for compatability[44]  ⍝5 Feb 2018: if example, write raw kernel too  (**temp for CLSB testing)[45]  ⍝12 Feb 2018: scale example by 1000 consistently[46]  ⍝9 Mar 2018: don't do old-style edge correction in EXAMPLE! It screws up CLSB comparisons, and isn't used for actual metric anyway[47]  ⍝27 Mar 2018: rectify X vs XX & calls from LINKAGES to do scaling by full kernel properly[48]  [49]  ⍝28 MAR 2018: TEMPORARY FIX TO USE FIXED BENCHMARK FOR LINKAGES    30 MAR: TEMPORARY REFIX![50]  [51]  [52]   buffer←B←4⊃A[53]   ⍎(0=⎕NC'linkages')/'linkages←0'    ⍝Global linkages; if set, skip edge correction, grid reading, and grid saving[54]   →(~linkages)/L1                    ⍝If called from linkages,[55]   downstream←correct←masktocore←0    ⍝   hardwire this when called from LINKAGES or FINDPATHS[56]   X Y ← 1⊃linkgrids                  ⍝   we've been passed modified lands (0 except for streams, MV outside of culvert window or beyond data), and mask[57]   Z←(⍴X)⍴0[58]   →(^/,0=Y←Y^~X∊0,MV)/L10            ⍝   only running for nonmissing stream centerline cells[59]   sr srt sd sdt ← 2⊃linkgrids        ⍝   we've been passed settings grids too[60]   P←3⊃linkgrids                      ⍝   and streamflow grid[61]  [62]   →L2                                ⍝Else, normal call[63]  L1:READPARS ME[64]   density←(1+~0∊⍴example) ⊃ density 1⍝Turn off density if running an example[65]   X←READ 1⊃1⊃A                       ⍝   Read landcover with streams[66]   Z←Z2←(⍴X)⍴0[67]   T←S (GRIDNAME 'include') 0 (masktocore/'aqconnect_core')[68]   Y←T INCLUDE X                      ⍝   Which cells to run for?[69]   :if masktocore[70]      Y N ← Y[71]      →(0∊⍴N)/0[72]   :end[73]   ⍎(0∊⍴Y)/'Y←(⍴X)⍴0'[74]   T←density|(block[1 2]×block[4 5]-1)⍝   Correction to prevent tile boundary artifacts[75]   Y[((1↑⍴Y)⍴T[1]⌽((density-1)⍴1),0)/⍳1↑⍴Y;]←0     ⍝   given density option, only build kernels for every nth cell[76]   Y[;((1↓⍴Y)⍴T[2]⌽((density-1)⍴1),0)/⍳1↓⍴Y]←0[77]   X←MVREP (X×1=Q←READ 2⊃1⊃A) (X=MV)  ⍝   Read stream centerlines - all land off centerlines gets zero[78]   :if v3                             ⍝   If running old version 3 for compatability,[79]      X←MVREP X (Q≠1)                 ⍝      FOR PRE 30 JAN 2018 RUNS, all off-centerline cells are missing (kept for compatability)[80]   :end[81]   →(^/,0=Y←Y^~X∊0,MV)/L10            ⍝   We're only running for stream centerline cells![82]   P←(Q=1)×READ 3⊃1⊃A                 ⍝   Read flow grid - only need it for centerline cells[83]   sr srt sd sdt ← SETTINGS (2⊃A) 'aquatic' 'resist dist' ⍝   Get ecological settings and tables for resistance and distance[84]  [85]  L2:fd←(2*¯1+⍳8),8 2⍴0 1 1 1 1 0 1 ¯1 0 ¯1 ¯1 ¯1 ¯1 0 ¯1 1[86]   V←LOOKUP resist                    ⍝Get resistance values set by cover type, not ecolgical distance[87]   V←(V⍪1)[V[;1]⍳X;2]                 ⍝Cover types not on list get no resistance (was 1E6 for Kevin's frag protocol)[88]   V←1E6 MVREP V (X∊0,MV)             ⍝Set resistance for off-centerline/off-landscape to a million[89]  [90]   T←⌈bandwidth×3÷cellsize[91]   E←SPREAD (bandwidth×3÷cellsize) (T+1) (T+1) ((2⍴1+2×T)⍴1)  ⍝Maximum possible kernel given search = 3[92]   E←(E≠0)×ZDENSITY 0⌈3-E÷bandwidth÷cellsize[93]   E←E÷(+/,E←(2⍴T-B)↓(-2⍴T-B)↓E)÷+/,E ⍝Scale to search = 3[94]  [95]  benchmark←+/,E   ⍝ TO USE FOR LINKAGES...MAYBE MORE[96]  [97]   D←(⍳1+2×B)-B+1                     ⍝Maximum radius possible to travel[98]   O←1E6×B<DIST 1+B×2                 ⍝Circle mask for search < 3[99]  [100]  M←(⍴X)⍴1                           ⍝Build edge correction matrix ----[101]  →((linkages≠0)∨(~correct)∨~0∊⍴example)/L5   ⍝If doing edge correction, and neither called from linkages or doing example,[102]  X2←READBLOCK (⊂GRIDNAME 1⊃1⊃A),(4↑THISBLOCK),2×B  ⍝   Read giant landcover grid--tile + 2×buffer (ugh!)[103]  S2←READBLOCK (⊂GRIDNAME 2⊃1⊃A),(4↑THISBLOCK),2×B  ⍝   and stream centerlines[104]  Y2←READBLOCK (⊂pathG PATH GRIDNAME 'include'),(4↑THISBLOCK),2×B  ⍝   Read giant (potentially masked) include grid[105]  →(~MV∊X2)/L5                       ⍝   Only have to do this if missing values in grid and not called by linkages,[106]  F←E÷+/,E                           ⍝   Kernel summing to 1[107]  I←B[108] [109]  [110] L3:→(((1↑⍴X2)-B)<I←I+1)/L5          ⍝   For each row,[111]  BREAKCHECK[112]  →((^/Y2[I;]∊0,MV)∨^/1≠B↓(-B)↓S2[I;])/L3[113]  J←B[114] L4:→(((1↓⍴X2)-B)<J←J+1)/L3          ⍝      For each column,[115]  →((Y2[I;J]∊0,MV)∨S2[I;J]≠1)/L4     ⍝         Only do for stream cells[116]  K←I+D ⋄ L←J+D[117]  →((^/(,F≠0)/,X2[K;L]=MV)∨~MV∊X2[K;L])/L4    ⍝         Skip if all MV or no MVs in window[118]  M[I-B;J-B]←÷+/,F×X2[K;L]≠MV        ⍝         Get edge correction factor for this cell[119]  →L4[120] [121] [122] L5:I←C←B×~linkages                                          ⍝Linkages runs for all cells--there's no avoided buffer[123]  E1 O1 ← E O[124]  [125]  :if ~0∊⍴example                    ⍝If running examples, [126]     watershed←READ 'Z:\LCC\GIS\Final\NER\caps_phase3\grids\watersheds_m'   ⍝***** READ WATERSHEDS FOR PRUNING EDGY STUFF THAT WONT MATCH UP[127]  :end [128]  [129] L6:→(((1↑⍴X)-C)<I←I+1)/L10                                  ⍝For each row, -----[130]  BREAKCHECK[131]  →(~∨/Y[I;])/L6                                             ⍝   If empty row, skip it[132]  J←C[133] L7:→(((1↓⍴X)-C)<J←J+1)/L6                                   ⍝   For each column,[134]  →(~Y[I;J])/L7                                              ⍝      If we're doing this cell,[135]  K←I+D ⋄ L←J+D[136]  →(~linkages)/L71                                           ⍝         If called from linkages,[137]  K←(T1←(K>0)^K≤1↑⍴X)/K                                      ⍝            Trim indices at edges[138]  L←(T2←(L>0)^L≤1↓⍴X)/L[139]  E←T1⌿T2/E1[140]  →(search≥3)/L71[141]  O←T1⌿T2/O1[142] L71:R←V[K;L][143]  →(0∊⍴sr)/L8                                                ⍝         If we have ecological settings for resistance[144]  R←1+multiplier×(srt[;2]×sr[;I;J]) EUDIST sr[;K;L]          ⍝         Resistance values for focal cell I,J.  Focal cell is always 0 for anthro settings.[145]  R←1E6 MVREP R (X[K;L]∊0,MV)                                ⍝         Missing cells/off-centerline cells get resistance of a million[146]  R←(V[K;L]×V[K;L]≠1)+R×V[K;L]=1                             ⍝         If cover type resistances are supplied, these take precedence[147] L8:→(search≥3)/L81                                          ⍝         If search < 3,[148]  R←R+O                                                      ⍝            Restrict to circle[149] L81:G←WETSPREAD (bandwidth×3÷cellsize) (K⍳I) (L⍳J) R (P[K;L])⍝         Spread through streamflow grid[150] [151]  :if ~0∊⍴example                    ⍝If running examples, [152]     →(1<⍴UNIQUENZ ,watershed[K;L]×G>0)/L7                   ⍝********** IF IN 2 OR MORE WATERSHEDS, SKIP THIS ONE--IT WONT MATCH UP[153]     Z2[K;L]←Z2[K;L]⌈G[154]  :end [155] [156]  raw←+/,G[157]  G←downstream DOWNSTREAM G (P[K;L]) (K⍳I) (L⍳J)             ⍝         If downstream only, mask kernel[158]  →((¯1=1↑block)∨0∊⍴example)/L9                              ⍝         If producing intermediate results from example,[159]  EXAMPLE T←1000×(bandwidth÷cellsize) 3 CONNECT_RESCALE G E ((⍴E)⍴1)[160]  [161] ⍝Write example number, big watershed, x, y, kernel, and rawkernel to text file (used for comparison with graph kernels)[162]  t←example[t⍳⌊/t←+/|example[;1 2]-((1↑⍴example),2)⍴1 FINDPOINT I J;3 4 1 2],(+/,T),raw[163]  t LOCKWRITE 'z:\LCC\GIS\Final\CLSB\kernels\grid_kernels.txt'[164] [165]  LOG '⊢[aqconnect] Point at ',(⍕⌊.5+FINDPOINT I J-B),' =',4⍕+/,T[166]  →L7[167]  [168] L9:G←(bandwidth÷cellsize) 3 CONNECT_RESCALE G E ((⍴E)⍴1)    ⍝         Rescale, but DON'T do edge correction like old connectedness![169] [170] G←(G×+/,E)÷benchmark  ⍝********************** TEMP FIX TO USE STANDARD BENCHMARK **************************[171]  [172]  R←(sdt[;2]×sd[;I;J]) ECODIST sd[;K;L]                      ⍝         Get ecological distance for focal cell I,J[173]  Z[K;L]←Z[K;L]+(density*2)×scalefactor×M[K;L]×1000×G×0 MVREP (1-R) (X[K;L]=MV)  ⍝         weight kernel by 1-ecological distance and adjust for density and scalefactor and edge correction[174]  →L7[175] [176] L10:→(~linkages)/L11                ⍝If called by linkages,[177]  res←MVREP Z (X∊0,MV)               ⍝   return result instead of writing grid[178]  →0[179] [180] L11:transparent←2                   ⍝Write transparently/summed[181]  →(0∊⍴Y)/0[182]  ⍎(0=⎕NC'N')/'N←Y'[183]  ⍎masktocore/'X←MVREP X (~N)'[184]  (MVREP Z (X∊0,MV)) WRITE 3⊃A[185]  :if ~0∊⍴example                    ⍝If running examples, write raw kernel (**temp for CLSB testing)[186]     Z2 WRITE (STRIPPATH 3⊃A),'rawaqconn'[187]  :end[188]  →0[189] [190] [191] what:CAPS resiliency[192] type:standard[193] direction:positive    ⍝Integrity metric - higher is bettter[194] init:head←1↓⎕TCHT MTOV MATRIFY 'number watershed x y kernel rawkernel' ⋄ (0 0⍴'') TMATOUT pathT PATH 'z:\LCC\GIS\Final\CLSB\kernels\grid_kernels.txt'    ⍝For sample kernels [195] info:('lands' (pathS PATH 'streams') (pathS PATH 'flow')) ('settings') ('aqconnect0') (⌈bandwidth×search÷cellsize) 'include'      ⍝Source grid, settings table, result grid, buffer size, and include grid[196] check:CHECKVAR 'multiplier bandwidth search density scalefactor resist masktocore correct downstream v3'[197] check:CHECKCOVER 'resist'[198] check:CHECKFILE pathT PATH scales    ∇