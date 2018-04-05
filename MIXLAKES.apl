﻿    ∇ A MIXLAKES S;buffer;B;X;P;I;Z;J;D;T;Q;M;E;U;G;H;mixtype;where;targets;R;limitsum;maskv;Y;block;N;V;background[1]   ⍝Mix settings variables and metric results within big lakes[2]   ⍝Runs as a CAPS table metric[3]   ⍝Inputs (in source\):[4]   ⍝   mixwater        Encoded mixwater targets[5]   ⍝   pondids         Grid of IDs for each pond[6]   ⍝   <grids>         Input grids to mix (in results\raw for metrics; in settings\raw for settings variables)[7]   ⍝   biglakes.txt    table of lakes[8]   ⍝   model\mix<where>.txt     list of grids to process, with mixtype in second column[9]   ⍝Parameters:[10]  ⍝   targets         Target lakes, should be biglakes.txt[11]  ⍝   where           Either 'metric' or 'settings'[12]  ⍝   mixtype         Defines the type of mixing that's being done.  Choices are:[13]  ⍝      'inflows'    Centerline mixing for rivers; wetlands and lentic get weighted mean of inflow cells[14]  ⍝      'sum'        Centerline mixing for rivers; wetlands and lentic get sum of inflow cells[15]  ⍝      'sumlogs'    Centerline mixing for rivers; wetlands and lentic get ⍟sum of *inflow cells (for log-scaled inputs)[16]  ⍝      'pond'       Centerline mixing for rivers; wetlands and lentic get mean of all non-missing cells in basin[17]  ⍝      'none'       No mixing for any cells; values are passed through directly for rescaling[18]  ⍝   background      Path to background version of metrics. If any MVs in metric grid, fill them with same grid in background path. For CSB.[19]  ⍝Results (in results\mixed\ for metrics, in \settings\mixed\ for settings variables):[20]  ⍝   <grids>         Result grids[21]  ⍝Must also run companion table metric, MIXWATER, simultaneously (to avoid killing shared result grid)[22]  ⍝Note: MIXLAKES does not do mixing for fringing wetlands.[23]  ⍝B. Compton, 8-14 Sep and 12 Oct 2010[24]  ⍝13 Oct 2010: add 'sums' mixing[25]  ⍝19 Oct 2010: Revise to new scheme (cells outside of lakes), add 'sumlogs' mixing[26]  ⍝25 Oct 2010: avoid trouble from rounding errors[27]  ⍝20 Jan 2012: if limitsum = yes, for mixtype∊'sum' 'sumlogs', don't allow result to go any higher than landscape-wide maximum[28]  ⍝   This is because, for Massachusetts CAPS, volume in communities below oceanic types could get absurdly high[29]  ⍝24 Jan 2012: trim buffer for lakes on N/W edge of landscape[30]  ⍝17-19 Sep 2012: call INCLUDE so mask and excluded are respected; 16 May 2013: pathG is default for include[31]  ⍝28 May 2013: add background parameter so we aren't burned by ponds that straddle watersheds when called from CSB. Sigh.[32]  ⍝11 Jul 2013: bail out if no lakes in table[33]  ⍝7 Mar 2014: was reading mixwater an extra time in loop[34]  ⍝7 May 2014: make sure comparison between mixwater and pondid is done with integers![35]  ⍝24 Jul 2015: instead of omitting lakes with missing target values, just omit those values (was failing at edge of landscape)[36]  [37]  [38]  [39]   READPARS ME[40]   T←MIXWATERGRIDS 'S'                        ⍝Get mixtype[41]   buffer←B←4⊃A[42]   G←2↓1⊃A                                    ⍝List of input grids[43]   H←3⊃A                                      ⍝and result grids[44]   ⍎(1=≡H)/'H←,⊂H'                            ⍝Undo scalar disclose from BUILDPAR[45]  [46]   M←0 1 1 TABLE pathT PATH targets           ⍝Read target table.  Must enforce sequential ids for all table metrics.[47]   →(M≡1 1⍴MV)/0                              ⍝Bail if table is empty[48]   M←0 1↓(M[;1]∊(⊃⊃S)+¯1+⍳2⊃⊃S)⌿M             ⍝Lakes that are our problem now[49]  [50]   I←0[51]  L1:→((⍴G)<I←I+1)/0                          ⍝For each input grid,[52]   →('none'≡TOLOWER I⊃mixtype)/L1             ⍝   if mixtype=none, don't do anything--MIXWATER will copy grid[53]   ⎕←I⊃G ⋄ FLUSH[54]  [55]   E←J←0[56]  L2:→((1↑⍴M)<J←J+1)/L4                       ⍝For each lake in table,[57]   BREAKCHECK[58]   D←(FINDCELL M[J;2 3]),FINDCELL M[J;4 5]-.01⍝   Convert MER to cells[59]   D[3 2 1 4]←D                               ⍝   and rearrange into upper left R,C, lower right[60]   D[3 4]←1+D[3 4]-D[1 2]                     ⍝   Upper left, number of cells[61]   D←1⌈D+¯1 ¯1 2 2×B                          ⍝   Buffer[62]   block←¯1[63]  [64]   X←READBLOCK (⊂pathG PATH 1⊃1⊃A),D          ⍝   Read mixwater[65]  [66]   Q←0≠0 MVREP READBLOCK (⊂pathG PATH GRIDNAME 'include'),D[67]   →(0∊⍴mask)/L21[68]   maskv←Q×0 MVREP READBLOCK (⊂mask),D[69]  L21:→(0∊⍴Y←S '' 1 INCLUDE (⍴X)⍴1)/L2        ⍝   Deal with include and mask grids here, then call INCLUDE[70]   P←0 MVREP READBLOCK (⊂pathG PATH 2⊃1⊃A),D  ⍝   and pond ids,[71]   P←Y×P                                      ⍝   Don't look at excluded cells[72]   Z←READBLOCK (⊂pathG PATH I⊃G),D            ⍝   Read metric grid[73]  [74]   :if (0≠⍴background)^MV∊Z                   ⍝   If background is set and there are missing values in metric grid,[75]      N←,READBLOCK (⊂path PATH background,STRIP I⊃G),D  ⍝      Read background metric[76]      V[T]←N[T←((,B BUFFER Y)^(MV=V)^N≠MV)/⍳⍴V←,Z][77]      Z←(⍴Z)⍴V                                ⍝      and replace missing cells with non-missing within buffer of mask[78]   :end[79]  [80]   Q←P=M[J;1]                                 ⍝   Cells in our lake[81]   U←(⌊X)=⌊.5+1000×(M[J;1]÷1000)-⌊M[J;1]÷1000 ⍝   Targets for inflow mixing[82]   U←U×X-1000×(M[J;1]÷1000)-⌊M[J;1]÷1000      ⍝   proportion for each target[83]   U←4 ROUND U                                ⍝   trim rounding errors introduced by Arc[84]   U←(T←,U≠0)/,U                              ⍝   list of proportions[85]   U←U÷+/U                                    ⍝   recalculate proportions so +/U≡1.0[86]   R←T/,Z                                     ⍝   corrsponding settings values[87]   E←E+MV∊R                                   ⍝   report missing values in target cells,[88]   R←(T←R≠MV)/R                               ⍝   omit any missing values in target cells[89]   U←U÷+/U←T/U                                ⍝   and rescale the rest[90]   →((0<+/,U)^~'pond'≡TOLOWER I⊃mixtype)/L3   ⍝   If mixing all lake cells (which we'll always do if nothing flows into lake),[91]   U←T DIV +/,T←Q×Z≠MV                        ⍝      Targets are all nonmissing cells in lake[92]   U←(T←,U≠0)/,U                              ⍝      list of proportions[93]   R←T/,Z                                     ⍝      corrsponding settings values[94]   E←E+T←^/,T=0                               ⍝      If all cells in lake are missing, give error[95]  L3:→(~∨/'sum' 'sumlogs'≡¨⊂TOLOWER I⊃mixtype)/L7⍝   If sum or sumlogs mixing,[96]   U←U≠0                                      ⍝      result is sum of inflows[97]   →('sum'≡TOLOWER I⊃mixtype)/L7              ⍝      If sumlogs,[98]   Z←(Z×~Q)+Q×⍟+/*R                           ⍝         treat inputs as logs[99]   →L8[100] L7:Z←Q×+/,U×R                               ⍝   lake gets weighted sum of target cells[101] L8:Z←Z⌊(⌈/,Z) ((1 GRIDDESCRIBE I⊃G)[9]) [1+limitsum^∨/'sum' 'sumlogs'≡¨⊂TOLOWER I⊃mixtype][102]  Z←MVREP Z (Q=0)                            ⍝   MVs everywhere outside of lake[103]  Z WRITEBLOCK (⊂pathG PATH I⊃H),D,0,1       ⍝   write grid transparently[104]  →L2[105] [106] L4:→(E=0)/L1[107]  LOG '*** Warning: missing values where data should be in ',((E≠0)/(⍕E),' lake',((E≠1)/'s')),' in ',I⊃G[108]  →L1[109] [110] [111] what:data prep[112] type:table[113] info:(((⊂pathS),¨'mixwater' 'pondids'), MIXWATERGRIDS 'S') ('') (MIXWATERGRIDS 'M') (1) 'lands'      ⍝Source grid, settings table, result grid, and buffer size[114] check:CHECKVAR 'where targets limitsum'[115] check:pathT CHECKFILE targets[116] check:(MIXWATERGRIDS 'S') CHECKVALUES 'mixtype inflows sum sumlogs pond none background'    ∇