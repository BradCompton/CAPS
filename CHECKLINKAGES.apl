﻿    ∇ CHECKLINKAGES;S;F;Q;T;E[1]   ⍝Make sure targets in LINKAGES exist in settings table, and make sure all targets are in scales[2]   ⍝B. Compton, 25 May 2010[3]   [4]   [5]   [6]    F←pathI PATH (2⊃GETINFO 'linkages') EXT 'par'                  ⍝Settings table name[7]    'Missing (or locked) settings table:' WARN (~IFEXISTS F)/F[8]    S←TOLOWER MIX (1 TABLE F)[;1]                                  ⍝Names of settings variables[9]    Q←TOLOWER (',',⎕TCHT) MATRIFY READHEAD T←pathT PATH targets    ⍝Read header of targets file (we already know it exists)[10]   Q←((⌈/Q MATIOTA MATRIFY 'x y x-coord y-coord'),0)↓Q            ⍝Target settings[11]   E←(0=S MATIOTA Q)⌿Q                                            ⍝Missing ones[12]   'Settings variables named in targets file missing from settings file:' WARN TELPRINT E[13]  [14]   S←TOLOWER MIX(1 TABLE pathT PATH scales)[;1]                   ⍝Scales[15]   E←(0=S MATIOTA Q)⌿Q                                            ⍝Missing ones[16]   'Settings variables named in targets file missing from scales file:' WARN TELPRINT E    ∇