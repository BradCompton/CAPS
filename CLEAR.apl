﻿    ∇ CLEAR;∆Z;∆T[1]   ⍝Erase anything bigger than 20k + selected parameters[2]   [3]    ⍞←(~'CAPS'≡STRIP ⎕WSID)/'¡¡¡ WARNING: Workspace is ',⎕WSID,', not CAPS !!!',⎕TCNL[4]    CLEANUP        ⍝Release buffers from grid DLL[5]    ∆Z←(20E3<⊃,/⎕SIZE¨↓⎕NL 2)⌿⎕NL 2[6]    ⍎(0≠⎕NC'set')/'∆Z←∆Z OVER set'     ⍝Parameters set by metrics[7]    ⍎(0≠⎕NC'∆set')/'∆Z←∆Z OVER ∆set'   ⍝and by SETPARS[8]   [9]    ∆T←⎕EX 'erased'[10]   anthilldir←''[11]   ∆Z←∆Z OVER MATRIFY 'target iter spread donut resist suffix cost head gridwindow headlab search self logfile makearc environ'[12]   ∆Z←∆Z OVER MATRIFY 'needtiles logbuf result seed iei_target iei_floor loc_floor need_floor represent_target iei_scale sys_target'[13]   ∆Z←∆Z OVER MATRIFY 'metric_pars metrics inputs wspars set cluster post community REST noarc'[14]   ∆Z←∆Z OVER MATRIFY 'year scenario loop blockid fileptr computername time firstblock noread block settings clear_results break test'[15]   ∆Z←∆Z OVER MATRIFY 'bandwidth classes values buffer multiplier threshold err friskonly checkland newdll example qtiles timestep'[16]   ∆Z←∆Z OVER MATRIFY 'xml index i tags rows disp mask refgrid'  ⍝ XMLCLEAR[17]   ∆Z←∆Z OVER MATRIFY 'pathI pathM pathP pathG pathR pathW pathA pathE pathD pathS pathT pathU pathF pathN pathQ pathH'[18]   ∆Z←∆Z OVER MATRIFY 'example blocks transparent friskonly checkland timestamp cluster post clear_results threshold newdll synonyms exclude landcover'[19]   ∆Z←∆Z OVER MATRIFY 'pars maxsunwindow streamvectors weatherhead targettable tragethead null biglakes port sunwindows strflow linkages finish'[20]   ∆Z←∆Z OVER MATRIFY 'dot override_pars override_metrics warnings crosstable tilemap tilemapinclude KK8 base watershedcall noland toomanyblocks mixtype crossings scales crossscores warn'[21]   ∆Z←∆Z OVER MATRIFY 'comment priority project owner timelimit tries gridwait cachewait computers notask projects tasks threads'[22]   ∆Z←∆Z OVER MATRIFY 'projects_ tasks_ computers_ threads_ defaults rpath aplpath aplworkspace rworkspace taskwait changed current iftrap switch slept sleep gridports maxthreads HELP'[23]   ∆Z←∆Z OVER MATRIFY 'house_bandwidth beach_bandwidth public_bandwidth D50 DS iei window workspace capsworkspace'[24]   ∆Z←∆Z OVER MATRIFY 'dams scores which scaleby uncertainty split backup onerror gridname maskbits lockserver uselockserver lockport lockwait rep'[25]   ∆Z←∆Z OVER MATRIFY 'allnames_FINDPATHS namestrip threadlimit locktimeout altmask fn substmosaics usemosaics where gridinfo gridinfofile lockpause'[26]   ∆Z←∆Z OVER MATRIFY 'mosaic mosaic_ mosaicwindow landscapewide mosaics writemosaics caching scramblesubtasks name recoverservers maxrecovery gridinitcount maxlocalgridinit maxsubtasks'[27]   ∆Z←∆Z OVER MATRIFY 'connections connections_ activeconnection referencewindow workingresolution workingcellsize cache scramble splittasks'[28]   ∆Z←∆Z OVER MATRIFY 'colsize rowsize cols rows panes lastrowsize lastcolsize panemap type source sourcetimestamp gridserver ∆set mosaicref zippars checkalign rflags webpath regionalpost'[29]   ∆Z←∆Z OVER MATRIFY 'synonyms inputsP resultsP ocean bigwatersheds splitsubtasks inputspar resultspar synonymspar landcoverpar lookedup thread futuregrids futurepath cachetimeout'[30]  [31]  [32]   ∆Z←∆Z OVER MATRIFY ((2×⍴∆T)⍴1 0)\∆T←'abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ'    ⍝All 1 letter variables[33]   ∆Z←((∆Z MATIOTA ∆Z)=⍳1↑⍴∆Z)⌿∆Z[34]   ∆Z←(2=⎕NC ∆Z)⌿∆Z  ⍝The above are variables, not functions![35]  [36]   ⍎(0≠⎕NC'toclear')/'∆Z←∆Z OVER ''toclear'' OVER MIX toclear'[37]  [38]   ∆T←⎕EX ∆Z[39]   →(0∊⍴∆Z)/L1[40]   erased←'Erased:'[41]   erased←erased OVER ' ',' ',' ',(⎕PW-3)TELPRINT ∆Z[42]   erased←MTOV erased[43]   ⎕←(⍕1↑⍴∆Z),' items erased.  Type ''erased'' to see them.'[44]  L1:RESET    ∇