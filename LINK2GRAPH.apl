﻿    ∇ A LINK2GRAPH S;M;buffer;targets;W;block;X;maskv;transparent;Z;Q;Y;I;B;L;J;K;N;T;nodes;edges;iei;flow;C;subs;cost;crossdam;nid;head;internode;fd;multiplier;anthroweight;bywatershed[1]   ⍝Build data for Critical Linkages Scenario Builder[2]   ⍝Tiny watersheds are done in companion metric LINK2GRAPHB[3]   ⍝Parameters:[4]   ⍝   targets         table of big watersheds[5]   ⍝   internode       distance (m) between internodes[6]   ⍝   subpath         name of subdirectory in tables\ (or full path) for results--can vary with internode[7]   ⍝   multiplier      multiplier on ecological distance for costs (same as used for AQCONNECT)[8]   ⍝   anthroweight    weight of abarriers, from AQRESIST[9]   ⍝   bywatershed     if yes, write separate output files for each big watershed (for testing & assessment) (will nuke joint files)[10]  ⍝Source data:[11]  ⍝   land            Landcover[12]  ⍝   streams         Stream centerline grid[13]  ⍝   flow            D8 flow direction grid[14]  ⍝   iei             Full IEI[15]  ⍝   aqresist        Aquatic resistance for natural settings (from AQRESIST)[16]  ⍝Results: (in tables\clsb\)[17]  ⍝   CLSBnodes.txt   nodeid, x, y, cost[18]  ⍝   CLSBedges.txt   node1, node2, length, cost, value (=IEI)[19]  ⍝Number of rows to run MUST be 1 in metrics.par[20]  ⍝Node id scheme:[21]  ⍝   1[4-digit watershed][6-digit node id]     [22]  ⍝   2[2-digit tile row][2-digit tile column][6-digit node id][23]  ⍝   *** ARE THERE FEWER THAN 1,000,000 confluences + culverts + internodes in all watersheds?  Mean of <1000 culverts/big watershed...[24]  ⍝   It looks like I'm good on this--I'll throw an error if numbers wrap, and I don't get it even with internode = 30[25]  ⍝To plot edges (for small areas) in ArcMap, use MAPEDGES[26]  ⍝B. Compton, 11 Jul 2017 (from COMPACT; today Donald Trump Jr.'s smoking gun email was released: collusion? "I love it")[27]  ⍝9 Aug 2017: incorporate natural aquatic resistance from AQRESIST[28]  ⍝11 Aug 2017: go to 1E5 nodes/watershed[29]  ⍝14 Aug 2017: format node ids to enough digits![30]  ⍝25 Aug 2017: I fucked up multiplier for crossings and forgot anthro/natural weights[31]  ⍝29 Aug 2017: no, don't want natural weights here, as AQRESIST already deals with that; add bywatershed option[32]  ⍝29 Aug 2017: ouch--go to 6-digit nodes...only needed because I'm testing with 30 m internodes[33]  ⍝25 Sep 2017: push results into tables\clsb\ for neatness[34]  ⍝12 Oct 2017: add subpath to facilitate testing at different scales[35]  ⍝25 Oct 2017: throw an error if any edges have a cost of zero--this should prevent some pain and suffering![36]  ⍝26 Oct 2017: set missing resistance very high--errors in streams/landcover over subtidal are screwing this up[37]  ⍝3 Nov 2017: well, that was bloody smart: I changed landcover to lands last week, so there were no culverts or dams in the nodes!  (yesterday: new Domane, but fucked up my knee on evil cleats)[38]  ⍝19 Feb 2018: round x and y to nearest m[39]  ⍝19 Mar 2018: allow subpath to be a complete path[40]  [41]  ⍝Note: must run LINK2GRAPHB as a companion[42]  [43]  [44]  [45]   READPARS ME[46]   buffer←0[47]   M←0 1 TABLE pathT PATH targets                 ⍝Read big watershed table[48]   ⎕ERROR (1≠2⊃⊃S)/'Error: block must be 1 in metrics.par!'[49]   W←,M[⊃⊃S;]                                     ⍝Item we're doing[50]  [51]   M←((M[;2]=2)^(M[;3 4]^.≥W[5 6]-cellsize)^M[;5 6]^.≤W[7 8]+cellsize)⌿M      ⍝Subwatersheds that fall within this watershed's MER[52]   subs←(M[;1 2]∨.≠W[1 2])⌿M                      ⍝Exclude this watershed, though[53]  [54]   W[5 6 7 8]←MER2CELLS W[5 6 7 8]                ⍝Convert MER to cells[55]   W[3 4]←buffer+1+(FINDCELL W[3 4])-W[5 6]       ⍝Watershed outflow in terms of grid[56]   block←¯1,W[5 6 7 8],buffer                     ⍝set block to our current window[57]   subs[;3 4]←↑1 FINDCELL¨↓subs[;3 4]             ⍝subwatersheds in terms of current window[58]  [59]   fd←(2*¯1+⍳8),8 2⍴0 1 1 1 1 0 1 ¯1 0 ¯1 ¯1 ¯1 ¯1 0 ¯1 1[60]  [61]  [62]  ⍝First: read input data & check mask[63]   X←READ 1⊃1⊃A                                   ⍝Read landcover[64]  [65]   C←1=READ 2⊃1⊃A                                 ⍝Read streams grid[66]   flow←READ 3⊃1⊃A                                ⍝And flow[67]   flow←0 MVREP flow (C≠1)                        ⍝want flow for stream centerlines only[68]  [69]   iei←0 MVREP READ 4⊃1⊃A                         ⍝Read IEI[70]   Q←READ 5⊃1⊃A                                   ⍝And cost of natural resistance (from AQRESIST)[71]   cost←1E6 MVREP Q (Q=MV)                        ⍝Anything missing in aqresist gets super-high resistance--this should just be subtidal            [72]  [73]   crossdam←READ 6⊃1⊃A                            ⍝aquatic barrier score [74]   crossdam←MVREP (crossdam×anthroweight×multiplier) (crossdam=MV)        ⍝Crossings & dams get weighted by anthroweight (from AQRESIST) and multiplier[75]   crossdam←MVREP crossdam (~X∊⊃,/LOOK¨↓MATRIFY'culvert/bridge dam')      ⍝aquatic barrier scores at crossings & dams; MV everywhere else[76]  [77]   nid←1E10+(W[1]×1E6)+1                          ⍝Node id is 1[4-digit watershed][6-digit node id][78]  [79]   nodes←0 4⍴0                                    ⍝nodes starts out empty--we'll add the node in the subroutine[80]   edges←0 5⍴0                                    ⍝edges start out empty[81]  [82]   nid 1 LINK2GRAPH_SUB W[3 4]                    ⍝Recursively climb up stream network, collecting nodes and edges[83]  [84]  [85]  ⍝⍝⍝⍝head←1↓⎕TCHT MTOV MATRIFY 'NID X Y RESIST' ⋄ nodes TMATOUT 'z:\LCC\TEMP\NODES-01.TXT'  ⍝*** FOR TESTING[86]  [87]   nodes[;1]←FRDBL¨(⊂12 0)⍕¨nodes[;1][88]   edges[;1 2]←FRDBL¨(⊂12 0)⍕¨edges[;1 2][89]   nodes[;2 3]←0 ROUND nodes[;2 3][90]   ⎕ERROR (0∊edges[;4])/'Error: zero-cost edges'[91]  [92]   :if bywatershed[93]      head←1↓⎕TCHT MTOV MATRIFY 'nodeid x y cost'[94]      nodes TMATOUT pathT PATH subpath,'\CLSBnodes',(⍕W[1]),'.txt'  ⍝Save results to unique text files for each watershed, replacing old results[95]      head←1↓⎕TCHT MTOV MATRIFY 'node1 node2 length cost value'[96]      edges TMATOUT pathT PATH subpath,'\CLSBedges',(⍕W[1]),'.txt'[97]   :else[98]      nodes LOCKWRITE pathT PATH subpath,'\CLSBnodes.txt'       ⍝Save results to text files[99]      edges LOCKWRITE pathT PATH subpath,'\CLSBedges.txt'[100]  :end[101]  →0[102] [103] [104] [105] what:data prep[106] type:table[107] init:head←1↓⎕TCHT MTOV MATRIFY 'nodeid x y cost' ⋄ (0 0⍴'') TMATOUT pathT PATH subpath,'\CLSBnodes.txt'    ⍝Create node and edge files on launch[108] init:head←1↓⎕TCHT MTOV MATRIFY 'node1 node2 length cost value' ⋄ (0 0⍴'') TMATOUT pathT PATH subpath,'\CLSBedges.txt'[109] info:((⊂'land'),((⊂pathS) PATH¨'streams' 'flow'),(⊂'iei-r'),(⊂pathR PATH 'aqresist'),⊂'abarriers') '' ('') (1) 'include'      ⍝Source grid, settings table, result grid, buffer size, and include grid[110] check:CHECKVAR 'internode targets multiplier anthroweight bywatershed subpath'[111] check:pathT CHECKFILE targets    ∇