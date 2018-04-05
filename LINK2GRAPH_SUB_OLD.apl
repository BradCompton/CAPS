﻿    ∇ N LINK2GRAPH_SUB_OLD I;J;L;E;C;O;T[1]   ⍝Recursive subroutine for LINK2GRAPH and LINK2GRAPHB: recurse up stream network from cell ⍵ for nodeid and outflow flag ⍺, collecting nodes and edges[2]   ⍝Global inputs:[3]   ⍝   flow (D8 flow for stream centerlines), iei, cost (cost of natural resistance), crossdam (resistance of culverts & dams), and subs (sub watersheds)[4]   ⍝Globally accumulated:[5]   ⍝   nid (node id)[6]   ⍝Global results:[7]   ⍝   nodes, edges [8]   ⍝B. Compton, 11-24 Jul 2017 (yesterday we caught a yellow-billed cuckoo!)[9]   ⍝14 Aug 2017: rework the way I deal with nodes at outflows[10]  ⍝29 Aug 2017: ouch--go to 6-digit nodes...only needed because I'm testing with 30 m internodes[11]  ⍝20 Dec 2017: was using 1.4 for diagonals, but AQCONNECT doesn't, so I shouldn't here so they match better[12]  ⍝28 Dec 2017: rework to take cost/length/IEI from half of origin cell and half of final cell to make symmetrical[13]  [14]   LAST VERSION BEFORE 23 JAN 2018 REWRITE[15]   [16]   N O ← N                                                            ⍝Node id and outflow flag (set if called from above at outflow)[17]   L←C←E←0                                                            ⍝Length, cost, and value to accumulate[18]  [19]  L1:                                                                 ⍝For each stream cell,[20]   :if O                                                              ⍝   If we're at the outflow/origin,[21]      L←L+cellsize÷2                                                  ⍝      accumulate a half cell of length from this cell to next--no diagonals![22]      C←C+cost[I[1];I[2]]÷2                                           ⍝      accumulate a half cell of cost[23]      E←E+iei[I[1];I[2]]÷2                                            ⍝      accumulate a half cell of IEI[24]   :end   [25]   [26]   J←flow FLOWINTO I                                                  ⍝   streams flowing into this one[27]  [28]   :if (crossdam[I[1];I[2]]≠MV)∨(1≠1↑⍴J)∨(L≥internode)                ⍝   If at a crossing or dam, a confluence, the end of the stream, or an internode,[29]      L←L+cellsize÷2                                                  ⍝      accumulate a half cell of length to the final cell in edge[30]      C←C+cost[I[1];I[2]]÷2                                           ⍝      accumulate a half cell of cost[31]      E←E+iei[I[1];I[2]]÷2                                            ⍝      accumulate a half cell of IEI[32]  [33]      :if (1=1↑⍴nodes)^O                                              ⍝      if inserting a node at the outflow,[34]         nodes[1;4]←0⌈crossdam[I[1];I[2]]                             ⍝         update the crossing score[35]         (⊂nid 0) LINK2GRAPH_SUB¨↓J                                   ⍝         and recurse up the network[36]      :else[37]         :if ∨/T←subs[;3 4]^.=I                                       ⍝      if we've hit a subwatershed,[38]            edges←edges⍪N,(1E11+((T⌿subs)[1;1]×1E6)+1),L,C,E          ⍝         we know subwatershed's nodeid, so make our edge linking to it, and we're done with this stream segment[39]         :else                                                        ⍝      else, create a normal node and edge[40]            nodes←nodes⍪(nid←nid+1),(1 FINDPOINT I),0⌈crossdam[I[1];I[2]]⍝      insert a node: node id, x, y, cost[41]            edges←edges⍪N,nid,L,C,E                                   ⍝      and save this edge: node1, node2, length, cost, and value (IEI)[42]            ⎕ERROR((nid÷1E6)=⌊nid÷1E6)/'Error: more than 100,000 nodes in watershed at watershed ',1↓⍕⌊(nid-1)÷1E5[43]            (⊂nid 0) LINK2GRAPH_SUB¨↓J                                ⍝      and recurse up the network[44]         :end[45]      :end[46]   :else                                                              ⍝   else, continue up stream[47]      :if ~O                                                          ⍝      If we're NOT at the outflow/origin,[48]         L←L+cellsize                                                 ⍝         accumulate length from this cell to next--no diagonals![49]         C←C+cost[I[1];I[2]]                                          ⍝         accumulate cost[50]         E←E+iei[I[1];I[2]]                                           ⍝         accumulate IEI[51]      :end[52]      [53]      I←,J[54]      O←0[55]      →L1[56]   :end    ∇