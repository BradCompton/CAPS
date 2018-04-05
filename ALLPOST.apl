﻿    ∇ ALLPOST W;X;override_metrics;override_pars[1]   ⍝Post-process multiple gradient for scales ⍵[2]   ⍝Default: ALLPOST 10 100 1000[3]   ⍝Note: must do MIXMETRICS beforehand![4]   ⍝And: frisking happens in individual threads, so watch Anthill for errors[5]   ⍝B. Compton, 7-8 Feb 2012[6]   [7]   [8]   [9]    ⍎(0∊⍴,W)/'W←10 100 1000'[10]  [11]   SETPATHS[12]   X←'; temporary table for post-processing'[13]   X←X OVER '; generated by ALLPOST ',NOW[14]   X←X OVER '; okay to delete'[15]   X←X OVER 'scale' OVER MATRIFY ⍕W[16]   X NWRITE pathT PATH 'postc.txt'[17]  [18]   override_metrics←1 4⍴'postc' 'yes' '*' 1[19]   X←'gradient = yes|postland = ''clusters*''|model = ''clustermodel*.par''|resultpath = ''gradient*\'''[20]   X←X,'|landtypes = ''''|checkland = no|posti = no|postby = ''''|mixmetrics = no'[21]   override_pars←('.|.',⎕TCNL) TEXTREPL '[caps]|project = ''allpost''|[postc]|targets = ''postc.txt''|[post]|',X[22]   CAPSx    ∇