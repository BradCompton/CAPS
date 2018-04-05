﻿    ∇ S BENCH P;A;X;Q;M;I;Z;T;R;block;loop;test;grids;ffile;L;J;B;IJ;K;t;V;head;u;E;C;G;U;a;O;W;D;N;Y;RL;RL_[1]   ⍝Find sample points in CAPS grids and build benchmark files post-processing[2]   ⍝   call with ⍵=0 to skip phases 1 and 2 (and use same points).  If weights.txt is changed, must start from scratch.[3]   ⍝Parameters:[4]   ⍝   ⍵[1]    maximum number of samples per community (default = 10,000)[5]   ⍝   ⍵[2]    number of quantiles (default = 100)[6]   ⍝   ⍵[3]    block size (default = 1000)[7]   ⍝   ⍵[4]    1 if using zero-pushed quantiles (default = 1 if running for metrics, 0 for iei or other indices)[8]   ⍝[9]   ⍝   ⍺[1]    0 for metrics/pass 1 only, 1 for metrics, 2 for iei, 3 for iei_i[10]  ⍝   ⍺[2]    scenario name[11]  ⍝[12]  ⍝   call with ⍵=0 to skip phases 1 and 2 (and use same points).  If weights.txt is changed, must start from scratch.[13]  ⍝Globals:[14]  ⍝   grid        name of landcover[15]  ⍝   postmetrics names of metrics, corresponds to columns of weights (except 1st)[16]  ⍝   weights     table of grid code, community weights[17]  ⍝   names       names of community classes, corresponds to rows of weights[18]  ⍝   gradient    yes if doing gradient post-processing[19]  ⍝   benchpoints saved benchmark points for reuse within a session[20]  ⍝   source      path to raw metrics; default = pathR[21]  ⍝   results     path to post results (default = pathE,'scaled\')[22]  ⍝   usebench    if expression evalues to false, skip benchmark creation and use existing table (or wait for it)[23]  ⍝   regionalpost 1 if called from REGIONALPOST[24]  ⍝   regionpath  path to region grids[25]  ⍝   region      if called from regionalpost, contains regionmap name and region[26]  ⍝Source:[27]  ⍝   landcover, metrics, [region maps if called from REGIONALPOST][28]  ⍝Results:[29]  ⍝   post\benchmarkn[g].csv[30]  ⍝   post\community-count[g].csv[31]  ⍝[32]  ⍝If called from REGIONALPOST,[33]  ⍝   1. Run only for tiles that fall in specified region (from regiontilemap<tilesize>.txt).[34]  ⍝   2. Only use cells that fall in region. Read region grid and screen cells.[35]  ⍝   3. (If running in expand mode, expand region before screening--not yet implemented - see writeup at bottom of function).[36]  ⍝   4. benchmark file is region-specific.[37]  ⍝[38]  ⍝Note: Missing values in metrics are treated as 0, i.e. as no stressor for stressor metrics, and no integrity for integrity metrics[39]  ⍝B. Compton, 30 Sep-2 Oct 2008[40]  ⍝12-15 May 2009: revised to sample equal # of points per community, in blocks...lots faster too![41]  ⍝6 Aug 2009: work properly with scenarios; if scenario-postfixed metric doesn't exist, use base name only[42]  ⍝28 Aug 2009: In pass 1 (⍵[1] ∊ 0,1), collect mean iei for each community and write to meaniei.csv[43]  ⍝1 Sep 2009: Default is 10,000 points per community--was too sloppy with 1,000[44]  ⍝19 Jan 2010: add lumping[45]  ⍝14 Apr 2010: drop metrics with 0 weight for all communities (is there any reason not to?)[46]  ⍝7 Jul 2010: Give error, not warning, if missing values in metrics that are being used![47]  ⍝7 Feb 2011: Use QTILEZ to push 0s into first quantile[48]  ⍝28 Mar-7 Apr 2011: revisions for new POST[49]  ⍝30 Jun 2011: fix zero-pushing bug[50]  ⍝21 Nov 2011: use _g for .csv and iei if gradient; only report top 10 missing communities[51]  ⍝20 Dec 2011: allow multiple indices, instead of just IEI[52]  ⍝22 Dec 2011: if usebench is false, don't create benchmark file[53]  ⍝7 and 8 Feb 2012: oops[54]  ⍝14 Feb 2012: Aargh! Communities with fewer than 10,000 samples got trailing MVs treated as 0s in quantiles[55]  ⍝19 Feb 2012: Add benchpath for usebench[56]  ⍝26 Mar 2012: return number of cells in each community in benchmark.csv and exclude empty rows; used by SCENARIOS for logistic rescaling[57]  ⍝29 Sep 2012: allow usebench to be numeric[58]  ⍝14 Jun 2013: deal properly with both benchpath and pathE[59]  ⍝27 Jan 2014: use SETTILE instead of noread←1 nonsense[60]  ⍝19-22 Mar 2014: changes for running under REGIONALPOST (see list above)[61]  ⍝25 Mar 2014: if running regionalpost, don't write community-count unless full extent[62]  ⍝20 Feb 2015: use inputs_metrics.par for metric name replacement (can't use inputs.par thanks to collisions)[63]  ⍝21-27 May 2015: when metric grids are missing, report error properly; 2-3 Jun 2015: do it right[64]  ⍝26 Oct 2015: give tile number when reporting missing data for metrics[65]  [66]  [67]  [68]   C S ← 2↑S,⊂''[69]   P←4↑P,(⍴,P)↓1E4 100 1000,C≤1                   ⍝Number of points to sample, percentiles, block size; use zero-pushing on metrics phase[70]  [71]   :if regionalpost[72]     RL←1 ⎕TCHT MATIN pathT,'regiontilemap',(⍕blocksize),'.txt'   ⍝Read the region tile map (created by REGIONTILE)[73]     RL_←FRDBL¨↓⎕TCHT MATRIFY head[74]     RL[;T]←⎕FI¨(⊂'.,. ') TEXTREPL¨1↓¨RL[;T←RL_ COL 'regions']    ⍝Unpack regions for each tile[75]     RL←(RL[;1]∊region[1])⌿RL                                     ⍝we only care about our regionmap[76]     :if ~0∊⍴RL[77]        RL←(∨/¨region[2]=RL[;4])⌿RL                               ⍝   and our region[78]     :end[79]   :end[80]  [81]  [82]   →(0=⎕NC'usebench')/L2[83]   →(0∊⍴usebench)/L2                              ⍝If usebench supplied,[84]   →(1=⍎'.←.=' TEXTREPL ⍕usebench)/L2             ⍝   if expression is true, create benchmark; otherwise, we'll use previously generated one[85]   K←0[86]  L1:→(IFGRIDEXISTS T←(benchpath,(0∊⍴benchpath)/pathE),'benchmark',(⍕C),(gradient/'g'),'.csv')/0     ⍝   wait for it to be created[87]   ⍎(2=K←K+1)/'LOG ''POST: Waiting for ',T,' to be created...'''[88]   Q←⎕DL 60[89]   →L1[90]  [91]  L2:a←⎕AI[2][92]   →(0=1↑P)/L12                                   ⍝If generating benchpoints,[93]  [94]  ⍝-----Pass 1: Count cells in each community by tile[95]   loop←test←noread←0 ⋄ grids←0 0⍴''              ⍝   Silly junk for BLOCK, etc.[96]   ffile←'BENCH (pass 1) ',⍕S[97]   BLOCK 2⍴B←P[3][98]   SETTILE[99]  [100]  LOG 'BENCH ',(⍕C,S),' Pass 1: Counting cells in each community by tile...' ⋄ FLUSH[101]  t←⎕AI[2][102]  L←((1↑⍴weights),×/block[6 7])⍴0                ⍝   # of cells in each community [community × tile][103] L3:BREAKCHECK ⋄ DOT                             ⍝   Repeat: read block (1st time through tiles),[104]  :if regionalpost^~'full'≡1⊃region              ⍝      if running for regions,[105]     →(~(⊂block[4 5])∊↓RL[;2 3])/L5              ⍝         only want tiles that fall in our region[106]  :end[107] [108]  X←READ GRIDNAME grid[109]  →(0∊⍴T←'*' INCLUDE X)/L5                       ⍝      apply mask and exclude[110]  X←(M←(,X≠MV)^,T≠0)/,X[111]  →(0∊⍴X)/L5                                     ⍝      If anything non-missing,[112] [113]  :if regionalpost^~'full'≡1⊃region              ⍝         if running for regions,[114]     T←READ GRIDNAME regionpath PATH 1⊃region    ⍝            read regionmap[115]     ⍝This is where we expand the region - see write-up below[116]     X←(M/,T=2⊃region)/X                         ⍝            and screen cells for our region[117]  :end[118] [119]  →(0∊⍴X)/L5                                     ⍝      If still anything non-missing,[120] ⍝ L[;block[4];block[5]]←+⌿X∘.=W[;1]             ⍝         (done in loop, below)[121]  J←0[122] L4:→((1↑⍴L)<J←J+1)/L5                           ⍝         Number of cells per community (vastly faster than ∘.=)[123]  L[J;block[5]+block[7]×block[4]-1]←+/X=weights[J;1][124]  →L4[125] L5:→(0≠NEXTBLOCK)/L3                            ⍝   Until no more blocks[126]  ⎕←''[127]  L←(T←∨/L≠0)⌿L                                  ⍝   Drop communities in weights table that don't exist in landcover[128]  :if 0∊⍴L                                       ⍝   If region is empty,[129]     :if regionalpost[130]        C←(⍕C),'_',(1⊃region),'_',(⍕2⊃region)[131]     :end[132]     '' NWRITE (benchpath,(0∊⍴benchpath)/pathE),'benchmark',(⍕C),(gradient/'g'),'.csv'[133]     ⎕←'No communities in this region.' ⋄ FLUSH[134]     →0[135]  :end[136]  N←T/names[137]  W←T⌿weights[138] [139]  Q←1                                            ⍝Write community.csv but not if running regionalpost other than full extent[140]  :if regionalpost[141]     Q←'full'≡1⊃region[142]  :end[143]  :if Q[144]     Q←N,(+/L),[1.5]4 ROUND 100×(+/L)÷+/,L[145]     head←'community,cells,percent'[146]     Q CMATOUT pathE,'community-count',(gradient/'_g'),'.csv'[147]  :end[148] [149]  Y←+/L                                          ⍝   Save counts to return in benchmark.csv[150]  L←⌊.5+L×⍉(⌽⍴L)⍴1⌊P[1]÷+/Q←L                    ⍝   Number of points to sample per tile & community (proportional to availability)[151] L6:→(^/0=T←1⌊¯1⌈(P[1]<+/Q)×P[1]-+/L)/L7         ⍝   Repeat: correction factor - some are high or low due to rounding proportions[152]  L←0⌈L+(Q>L)⌊(?(⍴T)⍴1↓⍴Q)⌽T,((⍴T),¯1+1↓⍴Q)⍴0    ⍝      Correct where there are points available[153]  →L6                                            ⍝   Until we've got what we want (as available)[154] [155] [156] ⍝-----Pass 2: Pick x,ys for each tile[157] L7:LOG 'BENCH ',(⍕C,S),' Pass 2: Picking sample points...' ⋄ FLUSH[158]  t←⎕AI[2][159]  M←((1↑⍴L),3,P[1])⍴0                            ⍝   Sampling points [community × 3 (tile, x, y) × points per community][160]  V←+\0,0 ¯1↓L                                   ⍝   Starting point (-1) for each community × tile[161] [162]  ffile←'BENCH (pass 2) ',⍕S                     ⍝   Reset block[163]  BLOCK 2⍴B[164] [165]  I←0[166] L8:→((1↓⍴L)<I←I+1)/L11                          ⍝   For each tile (2nd time),[167]  BREAKCHECK ⋄ DOT[168]  →(^/0=L[;I])/L10                               ⍝      If any community cells in tile,[169]  X←READ GRIDNAME grid                           ⍝         Read tile[170]  →(0∊⍴Q←'*' INCLUDE X)/L10                      ⍝      apply mask and exclude[171] [172]  :if regionalpost^~'full'≡1⊃region              ⍝         if running for regions,[173]     T←READ GRIDNAME regionpath PATH 1⊃region    ⍝            read regionmap[174]     ⍝This is where we expand the region[175]     Q←Q^T=2⊃region                              ⍝            and screen cells for our region[176]  :end[177] [178]  X←X×Q                                          ⍝         set masked cells to 0[179]  IJ←↓[1](⍉(⌽⍴X)⍴⍳1↑⍴X),[.5](⍴X)⍴⍳1↓⍴X           ⍝         Index matrix[180]  J←0[181] L9:→((1↑⍴L)<J←J+1)/L10                          ⍝         For each community,[182]  →(L[J;I]=0)/L9                                 ⍝            If in tile,[183]  Q←(,X=W[J;1])/,IJ                              ⍝               indices for this community[184]  M[J;;V[J;I]+⍳L[J;I]]←⍉I,↑Q[L[J;I]?⍴Q]          ⍝               sample points[185]  →L9[186] L10:T←NEXTBLOCK                                 ⍝   Next tile[187]  →L8[188] [189] L11:⎕←''[190]  :if ~regionalpost[191]     benchpoints←L M B W Y                       ⍝   Save benchmark points for later rounds[192]  :end[193]  →L13[194] L12:L M B W Y←benchpoints                       ⍝Else, use saved benchpoints[195]  V←+\0,0 ¯1↓L                                   ⍝   Remake starting points[196] [197] [198] ⍝-----Pass 3: Get quantiles & write benchmarkn.csv[199] L13:D←((D⍳D)=⍳⍴D)/D←index[200]  A←,C⊃postmetrics (D,¨⊂(gradient/'_g')) (⊂'iei_i')[201]  W←(C⌊2)⊃W (W[;,1],((1↑⍴W),⍴D)⍴1)[202] L14:loop←test←noread←0 ⋄ grids←0 0⍴''           ⍝   Silly junk for BLOCK, etc.[203]  ffile←'BENCH (pass 3) ',⍕S                     ⍝   Reset block[204] [205]  LOG 'BENCH ',(⍕C,S),' Pass 3: Getting quantiles...' ⋄ FLUSH[206]  t←⎕AI[2][207] [208]  G←0[209]  Q←(0,⍳P[2]-1)÷P[2]                             ⍝   quantiles[210]  Z←(0,P[2]+2)⍴0                                 ⍝   benchmark table [;1] = community, [;2] = metric, [;3..P[2]+2] = quantile[211]  I←0[212] L15:→((⍴A)<I←I+1)/L21                           ⍝   For each metric,[213]  BREAKCHECK[214]  U←FRDBL ⊃(⊃,/IFGRIDEXISTS¨U)/U←T←(⊂source) PATH¨0 'inputs_metrics' GRIDNAME (source (results,(1⊃region),'\raw')[C⌊2]),¨(A[I],¨S '')   ⍝Take scenario metric if it exists, otherwise just base name  MYSTERIOUS...[215]  U←(1+0∊⍴U)⊃ U (1⊃T)                            ⍝      If grid doesn't exist, make sure we have a name for error messages![216]  ⎕ERROR (~IFGRIDEXISTS U)/'Error: missing CAPS metric grid ',U[217]  LOG '   metric: ',(STRIP U),' ' ⋄ FLUSH[218]  u←⎕AI[2][219]  BLOCK 2⍴B[220]  E←0 2⍴0[221]  R←(⍴M)[1 3]⍴¯8888                              ⍝      samples for this metric[222]  J←0[223] L16:→((1↓⍴L)<J←J+1)/L19                         ⍝      For each tile (3rd time),[224]  BREAKCHECK ⋄ DOT[225]  →(^/0=L[;J])/L18                               ⍝      If any community cells in tile,[226]  X←READ U                                       ⍝         Read tile of metric (don't need to screen, as we have coordinates now)[227]  K←0[228] L17:→((1↑⍴L)<K←K+1)/L18                         ⍝         For each community,[229]  →(0=W[K;I+1])/L17                              ⍝            If weight is nonzero for this community×metric,[230]  →(L[K;J]=0)/L17                                ⍝            and present in this tile,[231]  R[K;V[K;J]+⍳L[K;J]]←T←X SCATI ⍉M[K;2 3;V[K;J]+⍳L[K;J]][232]  →(~MV∊T)/L17                                   ⍝            If missing data where there should be values,[233]  E←E⍪W[K;1],+/T=MV[234]  →L17[235] [236] L18:T←NEXTBLOCK                                 ⍝      Next tile[237]  →L16[238] [239] L19:⎕←''[240]  →(0=⍴E)/L20                                    ⍝   If any errors,[241]  G←1[242]  E←E[⍋E;][243]  LOG (6⍴' '),'Missing data in metric ',(STRIP U),' (tile ',(⍕block[4]),',',(⍕block[5]),') where there should be values for communities (# of missing sample points):'[244]  T←(MIX N[W[;1]⍳T/E[;1]],¨' ',¨,'(',¨(⍕¨O),¨')')[⍒O←(T←(E[;1]≠0,¯1↓E[;1])) pSUM E[;2];][245]  T←(((1↑⍴T),9)⍴' '),T←FRDBL (((10⌊1↑⍴T),1↓⍴T)↑T) OVER (10<1↑⍴T)⌿1 3⍴'...'[246]  LOG T[247]  FLUSH[248] L20:R←R×R≠MV                                    ⍝   Treat missing values as zeros--i.e., no stressor/no integrity[249]  R←MVREP R (R=¯8888)                            ⍝   Trailing missing values from metrics with < 10,000 samples go to MV so they're excluded from quantiles![250]  R←7 ROUND R                                    ⍝   Excess digits trash zero-pushing[251]  Z←Z⍪W[;1],A[I],7 ROUND↑(⊂Q (P[4])) QTILEZ¨↓R   ⍝   Quantiles for this metric - all zeros pushed into 1st group (=pseudoquantiles)[252]  →L15                                           ⍝   Next metric[253] [254] L21:LOG ''[255]  head←1↓','MTOV MATRIFY 'community metric count ',⊃,/' ',¨'q',¨⍕¨Q[256]  →(0∊⍴Z)/L22[257]  Z←(∨/0≠0 2↓Z)⌿Z[;⍳2],((1↑⍴Z)⍴Y),0 2↓Z          ⍝Add counts column, and drop rows for metrics that aren't used for a community[258] ⍝ Z←Z[;⍳2],((∨/0≠0 2↓Z)×(1↑⍴Z)⍴Y),0 2↓Z[259]  :if regionalpost                               ⍝If called from REGIONALPOST, benchmark is specific to region[260]     C←(⍕C),'_',(1⊃region),'_',(⍕2⊃region)[261]  :end[262]  Z CMATOUT T←(benchpath,(0∊⍴benchpath)/pathE),'benchmark',(⍕C),(gradient/'g'),'.csv'[263]  LOG 'Results written to ',T[264] L22:→(~G)/L23[265]  LOG ' > > >  There were errors in processing.  Some communities had missing values in metrics.  < < <' OVER ''[266] L23:LOG 'BENCH ',(⍕C,S),' is done.  Time = ',TIME ⎕AI[2]-a[267] [268] [269] ⍝Expandomatic in BENCH:[270] ⍝Throw an error if expand > tile size[271] ⍝When building RL, loop through fd, adding to rows & cols, and harvest all neighboring tiles[272] ⍝Use expand as buffer for all READs[273] ⍝Write EXPAND8, which expands binary matrix n cells.[274] ⍝    Add 1 cell of zeros around edges.[275] ⍝    Loop to n[276] ⍝       X←X∨(1⌽X)∨¯1⌽X[277] ⍝       X←X∨(1⊖X)∨¯1⊖X    ∇