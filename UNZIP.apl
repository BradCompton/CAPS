﻿    ∇ UNZIP D;X;S[1]   ⍝Unzip all .zip files in folder ⍵, recursively[2]   ⍝Once unzipped, original .zip files are renamed to _<old name>.zip, to facilitate deletion[3]   ⍝B. Compton, 20 Jan 2015[4]   [5]      HALF FINISHED...[6]   [7]    X←⎕LIB D[8]    X←(((1↑⍴X),⍴D)⍴D),X            ⍝Full path of each file[9]    S←((RJUST X)[;(⍴X)[2]]='\')⌿X  ⍝Subdirectories[10]  [11]   ASDF[12]   [13]   [14]         0 SUBDIRS¨↓S[15]      ∇