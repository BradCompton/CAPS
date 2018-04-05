﻿    ∇ SAMPLENPK;X;F;R;P;M;L;D;S;head;loop;test;noread;grids;B;block;Z;I;spread;W;A;J;K;T;Y;C;E;G;U;V;Q;H;H_;O;T1;T2;P1;S1;N[1]   ⍝Get samples for Betsy Homa's nutrient metric[2]   ⍝Builds resistant watershed for each sampling point, and summarizes several variables across this watershed[3]   ⍝Each variable gets both sum and time-of-flow weighted sum across the watershed[4]   ⍝Input tables:[5]   ⍝   \caps\more\npk\source\npksamples.txt    nutrient sampling points (site, x-coord, y-coord)[6]   ⍝   \caps\more\npk\source\ValidSiteList.txt list of sites from npksamples.txt to run for--subset to these[7]   ⍝   \caps\more\npk\landclasses.txt          classes for landcover[8]   ⍝   \gis\lithology\lithocode.txt            classes for lithology[9]   ⍝Input grids:[10]  ⍝   \caps\grids\land                CAPS landcover (types & groups to include are in .....)[11]  ⍝   \caps\source\flow               D8 flow direction grid[12]  ⍝   \caps\grids\wresist             watershed resistance (time of flow)[13]  ⍝   \caps\source\d8accum            D8 flow accumulation (for snapping points)[14]  ⍝   \caps\settings\raw\imperv       percent impervious[15]  ⍝   \gis\census2010\popdens2010     population density (people/acre) from 2010 census[16]  ⍝   \gis\lithology\lithology        lithology (attribute names are in \gis\lithology\lithocode.txt)[17]  ⍝   \caps\more\npk\source\tmax      max temperature (reprojected from HA)[18]  ⍝   \caps\settings\raw\mintemp      min temperature (from CAPS)[19]  ⍝   \caps\more\npk\source\pptmean   mean precip (reprojected from HA)[20]  ⍝   \caps\more\npk\source\septic    septic system data of some sort[21]  ⍝   \caps\more\ha\source\madischarge.txt  text file from madischarge.shp, point discharges from SYE (million gallons/day)[22]  ⍝Result:[23]  ⍝   \caps\more\npk\results\npk.txt  table of values for each nutrient sampling point[24]  ⍝B. Compton, 2 Aug 2012[25]  ⍝23 Aug 2012: subset to sites in ValidSiteList.txt.  Read points for discharge instead of grid, to sum correctly when multiple points in cell.[26]  ⍝31 Aug and 6 Sep 2012: add climate and septic data; 7 Sep: replace characters in header[27]  [28]  [29]  [30]   SETPATHS[31]   INIT[32]   loop←test←noread←0 ⋄ grids←0 0⍴''              ⍝Silly junk for BLOCK, etc.[33]   block←0[34]   spread←1E6[35]   E←2↑path[36]  [37]   F←READ '\caps\source\flow'                     ⍝Read these grids statewide[38]   R←1E6 MVREP READ '\caps\grids\wresist'[39]   A←READ '\caps\source\d8accum'[40]  [41]  [42]   S←TABLE '\caps\more\npk\source\npksamples.txt' ⍝Sampling points[43]   S←S[;(',' MATRIFY TOLOWER head) MATIOTA MATRIFY 'site x-coord y-coord'][44]   Q←TABLE '\caps\more\npk\source\ValidSiteList.txt'[45]   S←(S[;1]∊Q[;1])⌿S[46]   ⎕←'Subsetting to ',(⍕1↑⍴S),' sites.'[47]   S[;2 3]←↑FINDCELL¨↓S[;2 3]                     ⍝Convert locations to grid cells[48]  [49]   H←1 ⎕TCHT MATIN E,'\caps\more\ha\source\madischarge.txt' ⍝Read discharge points[50]   H_←⎕TCHT MATRIFY head[51]  [52]   U←0 ⎕TCHT 1 MATIN E,'\gis\lithology\lithocode.txt'[53]   V←0 ⎕TCHT 1 MATIN E,'\caps\more\npk\landclasses.txt'[54]  [55]   Y←MATRIFY 'site area imperv population discharge maxtemp mintemp meanprecip septic'[56]   Y←Y OVER MIX U[;2],V[;2][57]   Y←VTOM '. ._.-._.(..).' TEXTREPL MTOV Y[58]   Q←Z←S[;1],((1↑⍴S),¯1+1↑⍴Y)⍴0[59]  [60]   I←0[61]  L1:→((1↑⍴S)<I←I+1)/L2                           ⍝For each sampling point,[62]   BREAKCHECK[63]  [64]   X←M←P←L←T1←T2←P1←S1←0                          ⍝Make some space so we don't crash[65]  [66]   ⎕←'Point ',(⊃S[I;1]),' (',(⍕I),' of ',(⍕1↑⍴S),')' ⋄ FLUSH[67]   J←¯1 0 1∘.+S[I;2 3]                            ⍝   snap to flow (≤1 cell)[68]   S[I;2 3]←S[I;2 3]+2↑,(,T=⌈/,T←A[J[;1];J[;2]])⌿9 2⍴(3/¯1 0 1),[1.5]9⍴¯1 0 1[69]   W←F R RSHED S[I;2 3]                           ⍝   build resistant watershed[70]   W←W[1⊃K;2⊃K←CLIP W]                            ⍝   clip to watershed[71]   W←(W≠0)×(W-T)÷1-T←⌊/(,W≠0)/,W                  ⍝   rescale 0-1[72]   B←⊃,/(⊃¨K),⍴¨K                                 ⍝   MER[73]  [74]   X←0 MVREP READBLOCK (⊂E,'\caps\grids\land'),B  ⍝   Read these grids for watershed's MER[75]   M←0 MVREP READBLOCK (⊂E,'\caps\settings\raw\imperv'),B[76]   P←0 MVREP READBLOCK (⊂E,'\gis\census2010\popdens2010'),B[77]  ⍝ D←0 MVREP READBLOCK (⊂E,'\caps\more\ha\source\madisch'),B[78]   L←0 MVREP READBLOCK (⊂E,'\gis\lithology\lithology'),B[79]   T1←0 MVREP READBLOCK  (⊂E,'\caps\more\npk\source\tmax'),B[80]   T2←0 MVREP READBLOCK  (⊂E,'\caps\settings\raw\mintemp'),B[81]   P1←0 MVREP READBLOCK  (⊂E,'\caps\more\npk\source\pptmean'),B[82]   S1←0 MVREP READBLOCK  (⊂E,'\caps\more\npk\source\septic'),B[83]  [84]  ⍝Now get discharge, from points[85]   T←(FINDPOINT B[1 2]),FINDPOINT B[1 2]+B[3 4]-1        ⍝MER in map units[86]   D←(^/(O≥(⍴O)⍴T[1 4])^O≤(⍴O←H[;H_ COL 'x-coord y-coord'])⍴T[3 2])⌿H[;H_ COL 'x-coord y-coord cfd']      ⍝Discharge points in our grid[87]   D[;1 2]←(↑FINDCELL¨↓D[;1 2])-((1↑⍴D),2)⍴B[1 2]-1      ⍝Convert points to cells[88]   D←D[⍋D;][89]   T←¯1↓∨/(D[;1 2]⍪0)≠0⍪D[;1 2][90]   D←(T⌿D[;1 2]),T pSUM D[;3][91]   D←(B[3 4]⍴0) SCATR (D[;1 2]) (D[;3])           ⍝   discharge grid, finally[92]  [93]  [94]  ⍝Scale by G for mean, or C for per km^2[95]  [96]  [97]   Z[I;2]←Q[I;2]←C←(G←+/,W>0)×1E¯6×30*2           ⍝   watershed area (km^2)[98]  [99]   Z[I;3]←(+/,M×W>0)÷G                            ⍝   mean imperviousness[100]  Q[I;3]←(+/,M×W)÷+/,W                           ⍝   mean weighted imperviousness[101] [102]  Z[I;4]←(+/,P×W>0)÷G                            ⍝   mean population density[103]  Q[I;4]←(+/,P×W)÷+/,W                           ⍝   mean weighted population density[104] [105]  Z[I;5]←(+/,D×W>0)÷C                            ⍝   mean discharge/km^2[106]  Q[I;5]←(+/,D×W)÷+/,W                           ⍝   mean weighted discharge[107] [108]  Z[I;6]←(+/,T1×W>0)÷G                           ⍝   max temperature[109]  Q[I;6]←(+/,T1×W)÷+/,W[110] [111]  Z[I;7]←(+/,T2×W>0)÷G                           ⍝   min temperature[112]  Q[I;7]←(+/,T2×W)÷+/,W[113] [114]  Z[I;8]←(+/,P1×W>0)÷G                           ⍝   mean precip[115]  Q[I;8]←(+/,P1×W)÷+/,W[116] [117]  Z[I;9]←(+/,S1×W>0)÷C                           ⍝   septic systems/km≥2[118]  Q[I;N←9]←(+/,S1×W)÷+/,W                        ⍝   (N is last index used)[119] [120] [121] [122]  J←0[123] L3:→((1↑⍴U)<J←J+1)/L4                           ⍝   For each litho class,[124]  Z[I;N+J]←100×+/,((W>0)×L∊⎕FI ⊃U[J;1])÷G        ⍝      percent in this class[125]  Q[I;N+J]←100×+/,(W×L∊⎕FI ⊃U[J;1])÷+/,W         ⍝      weighted percent in this class[126]  →L3[127] [128] L4:J←0[129] L5:→((1↑⍴V)<J←J+1)/L1                           ⍝   For each landcover class (or group),[130]  Z[I;J+N+1↑⍴U]←100×+/,((W>0)×X∊⎕FI ⊃V[J;1])÷G   ⍝      percent in this class[131]  Q[I;J+N+1↑⍴U]←100×+/,(W×X∊⎕FI ⊃V[J;1])÷+/,W    ⍝      weighted percent in this class[132]  →L5[133] [134] L2:head←1↓⊃,/⎕TCHT,¨FRDBL¨↓Y[135]  Z TMATOUT T←E,'\caps\more\npk\results\npk.txt'[136]  Q TMATOUT U←E,'\caps\more\npk\results\npk_weighted.txt'[137]  ⎕←'Results written to ',T,' and ',U    ∇