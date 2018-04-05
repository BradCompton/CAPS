﻿    ∇ A ACORES S;bandwidth;B;buffer;I;X;W;Q;V;R;F;T;D;U;KK8;head;L;systems;slice;expand;toosmall;multiplier;M;transparent;dot;E;wresistrange;H;O;fd;N;wetmultiplier;accumrange;P;R2;O2;expandmult;J;sg;buf;S3;lentic;logistic;lakeresist;C;kernels;Y;Y2;dams;G;maxlake;result;selindex;combocores;X1;R1;representation;R1_;S1;goal;Z;upweight[1]   ⍝Build buffered aquatic reserve cores for LCD using resistant kernel & create kernel buffers too[2]   ⍝Input grids:[3]   ⍝   selindex        value grid (IEI or selection index)[4]   ⍝   land            landcover grid[5]   ⍝   flow            flow grid[6]   ⍝   wresist         time of flow aquaitc resistance[7]   ⍝   fd8accum        flow accumulation[8]   ⍝   streamclass     continuous stream class grid[9]   ⍝Input table (in tables\):[10]  ⍝   lakesizes.txt   pond, size (ha)[11]  ⍝Parameters:[12]  ⍝   selindex        name of selection index grid[13]  ⍝   result          name of result grid[14]  ⍝   systems         text file listing names of systems to include (usually aquatic.txt)[15]  ⍝   slice           include values > slice[1] in patches; slice[2] is used for lakes[16]  ⍝   expand          number of cells to expand to eliminate small gaps (usually 1)[17]  ⍝   toosmall        [1] drop tiny patches with this many cells or fewer; [2] for aquatic cores, drop streams with fewer than this many cells[18]  ⍝   multiplier      multiplier on value for costs[19]  ⍝   expandmult      multiplier for core expansion[20]  ⍝   accumrange      range of ln(d8flowaccum) across the region (use 5.8 20)[21]  ⍝   wetmultiplier   multiplier for aquatic cores at (min, max) watershed size[22]  ⍝   bandwidth       default bandwidth (h, or s.d. of kernel), in meters[23]  ⍝   logistic        inflection & scaling factor to use for resistance (use 0 for no logistic function)[24]  ⍝   lakeresist      additional resistance (in cells) to use for lentic when doing aquatic expansion (use 1E6 to treat lakes as barriers)[25]  ⍝   maxlake         size of largest lake allowed in cores (ha) [use 8094 ha = 20,000 acres][26]  ⍝   wresistrange    range of wresist grid, used to scale resistance for aquatic cores[27]  ⍝   buffer          number of cells to buffer tiles - should be radius of largest core + bandwidth÷cellsize[28]  ⍝   kernels         if yes, build buffer kernels, otherwise, just build seeds[29]  [30]  ⍝   combocores      grid of ecosystem + species cores, for 2nd pass where underrepresented cores are added; set to '' for 1st pass[31]  ⍝   representation  core representation table, from ACORESTATS[32]  ⍝   goal            goal for cores in 2nd pass, proportion (e.g., 0.25)[33]  ⍝   upweight        ceiling for upweighting (e.g., 0.02)[34]  ⍝Results:[35]  ⍝   cores           reserve kernels[36]  ⍝   coresS          centerline aquatic (2 = seed, 1 = expansion, 3 = lakes)[37]  ⍝B. Compton, 18-25 Jun 2014, from BUFFERCORES[38]  ⍝11 Jul 2014: expand stream cores downstream based on watershed area, and base multiplier on watershed area[39]  ⍝14 Jul 2014: don't expand into larger rivers; write seeds to help with evaluation[40]  ⍝22-23 Jul 2014: use resistance when expanding[41]  ⍝29 Jul 2014: don't expand aquatic cores downstream through dams[42]  ⍝8 Aug 2014: expand cores upstream as well as down[43]  ⍝21 Aug 2014: aquatic seeds in centerlines only, and clip enough so we don't cut off blobs because of extension[44]  ⍝22 Aug 2014: bug - lost patches completely surrounded by development[45]  ⍝25 Aug 2014: clip after extensions are done[46]  ⍝26-28 Aug 2014: don't restrict to centerlines for lakes; use toosmall[2] to screen combined aquatic seeds; write river-width seeds[47]  ⍝29 Aug 2014: only expand up into centerlines; was building random-sized blob![48]  ⍝9 Sep 2014: OMG: don't call bloody LOOK inside of loops!  It reads synonyms.par![49]  ⍝15-16 Sep 2014: add slice[2] for lentic[50]  ⍝17 Sep 2014: use land, not value grid for MVs, thanks to change in selection index[51]  ⍝29 Sep 2014: split expandup/expanddown, and add biggerok[52]  ⍝8 Oct 2014: add logistic resistance scaling for terrestrial cores[53]  ⍝9 Oct 2014: change biggerok to updownsize, going both directions[54]  ⍝15 Oct 2014: also use logistic resistance for aquatic cores (both for extensions and blobs)[55]  ⍝16 Oct 2014: add lakeresist[56]  ⍝21 Oct 2014: treat non-seed lentic extensions as lotic when dropping for toosmall[2][57]  ⍝23 Oct 2014: expand up from expansion too to get upstream from downstream expansion[58]  ⍝27 Oct 2014 and 7-10 Nov 2014: split from MAKECORES & rewrite expansion algorithm[59]  ⍝12 Nov 2014: use RKERNELS[60]  ⍝13 Nov 2014: add dams as barriers to expansion[61]  ⍝17 Nov 2014: screwed up kernels[62]  ⍝16-17 Jun 2016: use size cut-○ff for lentic--no lakes larger than maxlake in lakesizes.txt get cores[63]  ⍝12 Jul 2016: specify input & result in parameters.par to avoid inputs.par/results.par confusion[64]  ⍝15-19-21 Jul 2016: add 2nd pass[65]  [66]  [67]  [68]   READPARS ME[69]   lentic←LOOK 'lentic'[70]   dams←LOOK 'dam'[71]   X←READ 1⊃1⊃A                                   ⍝Read value grid[72]   W←READ 2⊃1⊃A                                   ⍝And landcover[73]   Q←0 ⎕TCHT MATIN pathI PATH systems,(~'.'∊systems)/'.txt'[74]  [75]   :if 0≠⍴combocores                              ⍝If doing 2nd pass,[76]      X1←READ GRIDNAME combocores                 ⍝   Read combo cores--we don't want seeds in them[77]      R1←1 ⎕TCHT MATIN representation             ⍝   read representation table from ACORESTATS[78]      R1_←⎕TCHT MATRIFY head[79]  [80]      S1←READ 8⊃1⊃A                               ⍝   Read stream class grid[81]      U←0⌈goal-R1[;R1_ COL 'percent']÷100         ⍝   Underrepresentation of stream classes[82]      U←1+upweight×(U-⌊/U)÷(⌈/U)-⌊/U                  ⍝   Upweight by underrepresentation, up to 2%[83]      U←LOOKUP U,R1[;,R1_ COL 'class'][84]      X←X×(U[;2],1)[U[;1]⍳S1]                     ⍝   and update selection index[85]   :end[86]  [87]  ⍝----- 1st pass: take slices, buffer and merge, and drop tiny patches -----[88]   Y←X×W∊(LOOKUP 0,Q)[;1]                         ⍝Set everything outside of selected systems in landcover to 0[89]  [90]   :if 0≠⍴combocores                              ⍝If doing 2nd pass,[91]      Y←Y×X1=MV                                   ⍝   don't allow seeds within combo cores[92]   :end[93]  [94]   Y2←Y≥(slice←2↑,slice,0)[1]                     ⍝Take values ≥ slice[1][95]   Y2←Y2×W≠lentic                                 ⍝drop our lentic slices[96]   Y2←Y2∨(W=lentic)^Y≥slice[2]                    ⍝and use slice[2] for lentic[97]  [98]   Y←((Y2≠0)^W≠MV)×expand BUFFER Y2               ⍝Buffer to merge fragments, but not across value = 0 or landcover = missing[99]   Y←FINDPATCH Y                                  ⍝Build patches (8-neighbor)[100] [101]  Q←(Q≠0)/Q←,Y[102]  Q←Q[⍋Q][103]  B←Q≠0,¯1↓Q[104]  Q←(B/Q),[1.5]B pSUM (⍴B)⍴1                     ⍝Patch #, number of cells[105]  Y←Y×Y∊U←(Q[;2]>(toosmall←2⍴toosmall)[1])/Q[;1] ⍝Drop tiny patches[106]  Y←MVREP Y ((W=MV)∨X=MV)                        ⍝Carry over missing cells in landcover or value[107] [108]  buf←1+⌈bandwidth÷cellsize                      ⍝Buffer; take 1 extra cell to deal with rounding[109]  D←(⍳1+2×buf)-buf+1                             ⍝Maximum radius possible to travel[110]  KK8←8 2⍴¯1 0 1 0 0 ¯1 0 1 ¯1 ¯1 1 1 ¯1 1 1 ¯1  ⍝8-neighbor rule for FOCALMIN[111]  Z←(⍴X)⍴0[112] [113]  I←0[114]  E←READ 3⊃1⊃A                                   ⍝Read flow grid[115]  R←READ 4⊃1⊃A                                   ⍝and time of flow resistance[116]  H←READ 5⊃1⊃A                                   ⍝and flow accumulation[117]  [118]  sg←1=READ 6⊃1⊃A                                ⍝and stream centerlines[119]  fd←(2*¯1+⍳8),8 2⍴0 1 1 1 1 0 1 ¯1 0 ¯1 ¯1 ¯1 ¯1 0 ¯1 1[120]  N←FINDPATCH W=lentic                           ⍝Identify all lakes[121]  Y←FINDPATCH Y⌈N∊T←(T≠0)/T←,N×Y≥1               ⍝Light up entire lakes that our cores fall into & rebuild cores[122] [123]  P←READ 7⊃1⊃A                                   ⍝Read pond ids[124]  L←TABLE pathT PATH 'lakesizes.txt'             ⍝and table of big lake sizes[125]  Y←Y×(W≠lentic)∨~P∊(L[;2]>maxlake)/L[;1]        ⍝Drop any lakes that are bigger than maxlake threshold[126] [127]  Y←Y×sg∨N≠0                                     ⍝only want centerlines for rivers; all cells for lakes[128]  U←((U⍳U)=⍳⍴U)/U←(,Y≠0)/,Y                      ⍝rebuild unique core list[129]  ⍞←'Building seeds for ',(⍕⍴U),' cores',MB ⋄ FLUSH[130] [131] [132] ⍝----- 2nd pass: build expanded aquatic cores -----[133]  C←(Y≠0)^W≠lentic                               ⍝Lentic slices - these are where we spread from[134]  P←expandmult RESIST 1-X[135]  P←P+1E6×(W∊dams)∨~sg                           ⍝Use only stream centerlines; dams are barriers[136]  P←P+lakeresist×W=lentic                        ⍝increase resistance for lakes[137]  V←0≠buf C 1 2 RKERNELS P                       ⍝build kernels[138] [139] [140] ⍝----- 3rd pass: build kernels for cores we're keeping -----[141] L3:N←(N≠0)^Y≠0                                  ⍝Seed lakes[142]  Y←FINDPATCH V                                  ⍝Build patches on centerlines for each lotic core (can include lentic extensions)[143]  Q←(Q≠0)/Q←,Y[144]  Q←Q[⍋Q][145]  B←Q≠0,¯1↓Q[146]  Q←(B/Q),[1.5]B pSUM (⍴B)⍴1                     ⍝Patch #, number of cells[147]  Y←Y×Y∊(Q[;2]>toosmall[2])/Q[;1]                ⍝Drop tiny patches of lotic (plus lentic when in extensions) smaller than toosmall[2][148]  V←((Y≠0)+C^Y≠0)⌈3×N≠0                          ⍝kept seeds (1 = extension, 2 = seed lotic, 3 = seed lentic)[149] [150]  Y←Y⌈(N≠0)×(⌈/,Y)+FINDPATCH N≠0                 ⍝Patches for seed lakes[151]  U←((U⍳U)=⍳⍴U)/U←(U≠0)/U←,Y                     ⍝Unique patches[152] [153]  →(~kernels)/L7[154]  ⍞←⎕TCNL,'Building kernels for ',(⍕⍴U),' cores',MB ⋄ FLUSH[155] [156]  I←0[157] L4:→((⍴U)<I←I+1)/L7                             ⍝For each core,[158]  BREAKCHECK[159]  DOT[160]  S←Y=U[I]                                       ⍝   Select cells in core[161]  L M ← buf CLIP S                               ⍝   Clip to this core plus buffer[162]  S←S[L;M][163]  O2←(INDICES O←O=⌈/,O←H[L;M]×S)[1;]             ⍝   Identify bottommost cell--we'll always keep this in; O2 is indices[164] [165]  C←O∨S^0≠E[L;M] UPFLOW ~S                       ⍝   find "edges"--cells in core that stuff flows into from outside[166]  C←INDICES C                                    ⍝   make list of indices[167]  G←(⍴S)⍴0[168]  :if (W[L;M][O2[1];O2[2]])=lentic               ⍝   if it's a lake,[169]     P←multiplier                                ⍝      use standard multiplier[170]  :else                                          ⍝   else, for rivers,[171]     F←⍟H[L;M][O2[1];O2[2]]                      ⍝      ln(flow accumulation at botttommost cell of core before expansion)[172]     P←wetmultiplier[1]+(-/wetmultiplier[2 1])×(F-accumrange[1])÷-/accumrange[2 1]    ⍝   multiplier is a function of watershed area[173]  :end[174]  R2←P RESIST (R-wresistrange[1])÷wresistrange[2]⍝rescale time of flow into resistance[175] [176]  J←0[177]  dot←⍴⍞←⎕TCNL,(⍕I),' of ',(⍕⍴U),' cores, ',(⍕1↑⍴C),' cells',MB ⋄ FLUSH[178] L5:→((1↑⍴C)<J←J+1)/L6                           ⍝   For each "edge" cell,[179]  DOT[180]  G←G⌈(÷buf)×WETSPREAD buf (C[J;1]) (C[J;2]) (R2[L;M]) (E[L;M])   ⍝      Build kernel[181]  →L5[182] [183] L6:Z[L;M]←Z[L;M]⌈S⌈E[L;M] CORE_WATERSHED G S    ⍝   mask kernel so we only build upstream of core[184]  →L4[185] [186] L7:⎕←''[187]  :if 0≠⍴combocores                              ⍝If doing 2nd pass,[188]     V←(0 MVREP X1)+(X1=MV)×(11×V∊1 2)+20×V=3    ⍝   result is 1st pass combo cores plus these new cores[189]  :end[190] [191]  transparent←3                                  ⍝Use max transparency mode[192]  :if kernels[193]     (MVREP Z ((W=MV)∨Z=0)) WRITE (3⊃A),'k'      ⍝   Save kernels transparently, with all 0's set to missing[194]  :end[195]  (MVREP V (V=0)) WRITEI 3⊃A                     ⍝Write centerlines[196] ⍝ S3←MIXRIVER V                                  ⍝fill in off-cenerline cells for seeds[197] ⍝ S3←S3-(V=0)^S3=2                               ⍝all filled-out river cells count as expansion[198] ⍝ (MVREP S3 (S3=0)) WRITEI(3⊃A),'w'              ⍝Write full-river seeds[199]  →0[200] [201] [202] [203] what:auxiliary[204] type:standard[205] info:(selindex 'land' 'flow' (pathS,'wresist') 'fd8accum' 'streams' 'pondids' 'streamclass') ('') (result) (buffer⌈⌈bandwidth÷cellsize)       ⍝Source grid, settings table, result grid, and buffer size[206] check:CHECKVAR 'systems slice expand toosmall multiplier bandwidth buffer wetmultiplier accumrange expandmult logistic lakeresist maxlake kernels selindex result combocores representation goal upweight'    ∇