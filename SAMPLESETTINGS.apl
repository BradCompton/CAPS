﻿    ∇ SAMPLESETTINGS;X;Q;M;I;Z;T;noread;block;loop;test;grids;ffile;L;J;B;IJ;V;head;ifchat;fn;pars;postland;blocksize;samples;S;drop;round;N;landcover;ss;Y;A[1]   ⍝Sample settings variables across landscape for gradient rescaling (step 1)[2]   ⍝Parameters (in parameters.par [samplesettings]):[3]   ⍝   postland = 'postland'               name of landcover grid for post-processing[4]   ⍝   samples = 1E4                       how many samples? Default is 1,000,000[5]   ⍝   blocksize = 1000                    block size to use[6]   ⍝   drop = 'soilph soiltex soildepth'   settings variables to drop (because of missing data)[7]   ⍝   scales = 'scalesettings.txt'        scales of settings variables (global, in [caps])[8]   ⍝Result:[9]   ⍝   post\samplesettings.txt             postland class and settings variables for sampled points[10]  ⍝   post\landscapesize.txt              area of the landscape, in km^2, excluding ocean[11]  ⍝Note: rescaling settings by weights happens in next step, cluster.settings()[12]  ⍝B. Compton, 15-16 Nov 2011 (from BENCH)[13]  ⍝19 Dec 2011: settings variables are unscaled on disk--do it here[14]  ⍝2 Feb 2012: write landscape area[15]  ⍝27 Jan 2014: use SETTILE instead of noread←1 nonsense[16]  [17]  [18]  [19]   SETPATHS[20]   INIT[21]   (pathP PATH 'caps.log') LOG '--- Starting run of SAMPLESETTINGS, ',NOW,' ---'[22]   ifchat←0[23]   pars←NREAD pathI PATH 'parameters.par'[24]  [25]   READPARS fn←'caps'[26]   READPARS fn←'samplesettings'[27]  [28]   landcover←¯1 TABLE landcoverpar[29]  [30]   S←TABLE 'settings'                             ⍝Get names of natural settings variables[31]   S←(S[;2]≡¨⊂'natural')/S[;1][32]   S←(~(⍳⍴S)∊S⍳FRDBL¨↓MATRIFY drop)/S             ⍝Drop bad settings variables in 'drop' (soils, which brim with missing data)[33]   S←(⊂pathG PATH postland),S                     ⍝Landcover is 1st 'setting'[34]   ss←MATIN pathT PATH scales                     ⍝Get original settings variable scales[35]  [36]  [37]  [38]  ⍝-----Pass 1: Count cells in each tile[39]   loop←test←noread←0 ⋄ grids←0 0⍴''              ⍝Silly junk for BLOCK, etc.[40]   ffile←'SAMPLESETTINGS (pass 1) '[41]   BLOCK 2⍴B←blocksize[42]   SETTILE[43]  [44]   LOG 'SAMPLESETTINGS, Pass 1: Counting cells in each tile...' ⋄ FLUSH[45]   A←L←(×/block[6 7])⍴0                           ⍝# of cells in each tile][46]  L1:BREAKCHECK                                   ⍝Repeat: read block[47]   ⍞←'.' ⋄ FLUSH[48]   X←Y←READ GRIDNAME postland[49]   X←(X≠MV)^~X∊0 'groups.par' LOOKUP 0,2 1⍴'do'   ⍝   All but developed and ocean[50]   L[block[5]+block[7]×block[4]-1]←+/,X           ⍝   number of undeveloped cells in block[51]   Y←(Y≠MV)^~Y∊0 'groups.par' LOOKUP 0,1 1⍴'o'    ⍝   All but ocean[52]   A[block[5]+block[7]×block[4]-1]←+/,Y           ⍝   total number of cells in block[53]  [54]   →(0≠NEXTBLOCK)/L1                              ⍝Until no more blocks[55]  [56]   ⎕←''[57]   LOG '   ',(FRDBL,'CI15' ⎕FMT +/L),' undeveloped cells in landscape.  Sample of ',(FRDBL,'CI15' ⎕FMT samples),' is ',(FRDBL 3⍕100×samples÷+/L),'% of the landscape.'[58]   L←⌊.5+L×(samples×1.1)÷+/L                      ⍝Number of points per block to get samples - oversample by 10%[59]   N←+/L                                          ⍝Actual total number of samples[60]  [61]   A←((+/A)×CELLSIZE*2)÷1E6                       ⍝Area of landscape in km*2[62]   ((⍕A),⎕TCHT,'; Area of landscape in km^2 (excluding ocean)') NWRITE T←pathE PATH 'landscapesize.txt'[63]   LOG 'Landscape area (',(FRDBL ,'CI15' ⎕FMT A),' km^2) written to ',T[64]  [65]  [66]  ⍝-----Pass 2: Pick x,ys for each tile[67]  L2:LOG 'SAMPLESETTINGS, Pass 2: Picking sample points...' ⋄ FLUSH[68]   M←(N,5)⍴0                                      ⍝Sampling points (tile, x, y)[69]  [70]   ffile←'SAMPLESETTINGS (pass 2)'                ⍝Reset block[71]   BLOCK 2⍴B[72]  [73]   I←0[74]  L3:→((⍴L)<I←I+1)/L5                             ⍝For each tile,[75]   →(L[I]=0)/L4                                   ⍝   If any undeveloped cells in tile,[76]   BREAKCHECK[77]   ⍞←'.' ⋄ FLUSH[78]   X←READ GRIDNAME postland                       ⍝      Read tile[79]   X←(X≠MV)^~X∊0 'groups.par' LOOKUP 0,2 1⍴'do'   ⍝      All but developed and ocean[80]   IJ←↓[1](⍉(⌽⍴X)⍴⍳1↑⍴X),[.5](⍴X)⍴⍳1↓⍴X           ⍝      Index matrix[81]   Q←(,X)/,IJ                                     ⍝      X,Ys of undeveloped cells[82]   V←+\0,¯1↓L                                     ⍝      starting point (-1) for each tile[83]   M[T←V[I]+⍳L[I];⍳3]←I,↑Q[L[I]?⍴Q]               ⍝      sample points[84]   M[T;4 5]←↑1 FINDPOINT¨↓M[T;2 3]                ⍝      save X,Ys for reporting nodata cells[85]  L4:T←NEXTBLOCK                                  ⍝   Next tile[86]   →L3[87]  [88]  [89]  ⍝-----Pass 3: Get sample points[90]  L5:loop←test←noread←0 ⋄ grids←0 0⍴''            ⍝Silly junk for BLOCK, etc.[91]   ffile←'SAMPLESETTINGS (pass 3)'                ⍝Reset block[92]  [93]   ⎕←''[94]   LOG 'SAMPLESETTINGS, Pass 3: Getting sample points...' ⋄ FLUSH[95]  [96]   ss←ss[(TOLOWER MIX ss[;1]) MATIOTA TOLOWER MIX S;]  ⍝Reorder settings scales to match our settings variables[97]   Z←(N,⍴S)⍴0[98]   I←0[99]  L6:→((⍴S)<I←I+1)/L9                             ⍝For each settings variable,[100]  BREAKCHECK[101]  LOG ⎕TCNL,'   Reading ',I⊃S ⋄ FLUSH[102]  ⍞←'   '[103]  BLOCK 2⍴B[104]  J←0[105] L7:→((⍴L)<J←J+1)/L6                             ⍝   For each tile,[106]  →(L[J]=0)/L8                                   ⍝   If any cells in tile,[107]  ⍞←'.' ⋄ FLUSH[108]  X←READ pathN PATH GRIDNAME I⊃S                 ⍝      Read tile of settings variable[109]  X←X SCATI M[V[J]+⍳L[J];2 3]                    ⍝      sample cells we want[110]  X←MVREP ((X-ss[I;2])÷-/ss[I;3 2]) (X=MV)       ⍝      rescale settings variables[111]  Z[V[J]+⍳L[J];I]←X[112] L8:T←NEXTBLOCK                                  ⍝   Next tile[113]  →L7[114] [115] L9:⎕←''[116]  →(~MV∊Z)/L10[117]  LOG '*** Warning: Missing values (total of ',(⍕+/,Z=MV),' cells) in grids:'[118]  LOG ' ',' ',' ',(60⌊⎕PW-3) TELPRINT MIX (∨⌿Z=MV)/(STRIP¨S),¨' ',¨'(',¨(⍕¨+⌿Z=MV),¨')'[119]  LOG '*** Cases with missing values (',(⍕+/∨/Z=MV),') have been dropped.  You may want to use'[120]  LOG '***  drop= in parameters.par and rerun SAMPLESETTINGS to exclude these variables.'[121]  Q←(B←∨/Z=MV)⌿M[;4 5][122]  Q←Q,DEB¨↓⍕((⊂''),STRIP¨S)[1+((B⌿Z)=MV)×((+/B),⍴S)⍴⍳⍴S][123]  head←1↓⎕TCHT MTOV MATRIFY 'x-coord y-coord grids'[124]  Q TMATOUT T←pathE,'missingsamples.txt'[125]  LOG 'Points with missing samples written to ',T[126]  Z←(~B)⌿Z                                       ⍝Drop missing cases[127] [128] L10:LOG ''[129]  Z←Z[samples?1↑⍴Z;]                             ⍝Sample down to requested n[130] [131]  head←1↓⊃,/⎕TCHT,¨STRIP¨S[132]  Z←round ROUND Z                                ⍝Round to a few digits (3 or 4)[133]  Z TMATOUT T←pathE,'samplesettings.txt'[134]  LOG 'SAMPLESETTINGS is done. Results written to ',T    ∇