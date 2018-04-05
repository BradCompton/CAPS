﻿    ∇  SORTLABELS A;F;I;C;M;B;R;T;P[1]    ⍝Sorts labels of the form 'L#' in functions ⍵[2]    ⍝ Syntax:  ]SORTLABELS  functions   /L=label prefix (e.g., L)[3]    ⍝ Sorts labels that have a the specified prefix followed by a digit[4]    ⍝   (which may be followed by any text, as in L15, L15B, etc.)[5]    ⍝   but does not change any other labels.[6]   [7]    ⍝[8]    P←'L'⍝default label prefix[9]    →(~1∊B←A ⎕SS'/L')/⍙2⍝If /L= option used,[10]   P←(1+B⍳1)↓A[11]   P←(¯1+P⍳'/')↑P[12]   P←FRDBL(P⍳'=')↓P⍝   get the label prefix[13]  ⍙2:P←,P[14]   F←MATRIFY(¯1+A⍳'/')↑A⍝function names[15]   I←0[16]  ⍙1:→((1↑⍴F)<I←I+1)/⍙3⍝Loop for each function[17]   ⍞←F[I;][18]   C←⎕CR F[I;][19]   M←(∨/C=':')⌿C ⍝   lines which may be labelled[20]   B←,^\M≠':' ⋄ M←(⍴M)⍴B\B/,M⍝   text before first colon[21]   M←MATRIFY,' ',(^/M∊' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_∆⍙0123456789')⌿M ⍝   the labels[22]   →((M MATIOTA M)^.=⍳1↑⍴M)/⍙6[23]   ⎕←' -  * * *  Has duplicate labels; sorting bypassed.  * * *'[24]   →⍙1[25]  ⍙6:M←((⍴M)⌈0,1+⍴P)↑M[26]   M←(M[;⍳⍴P]^.=P)⌿M⍝   labels with the right prefix[27]   M←(M[;1+''⍴⍴P]∊'0123456789')⌿M ⍝   followed by a digit[28]   →(0≠1↑⍴M)/⍙4[29]   ⎕←' - has no labels' ⋄ →⍙1[30]  ⍙4:B←''⍴⍴M[31]   R←,'/',M,'/',((B,⍴P)⍴P),⍕(B,1)⍴⍳B⍝   old and new labels[32]   C←(R~' ')WORDREPL MTOV C⍝   make the changes[33]   T←⎕FX VTOM C[34]   →(T≡F[I;]~' ')/⍙5[35]   ⎕←' -  * * *  Unable to redefine this function.  * * *'[36]   →⍙1[37]  ⍙5:⎕←' - ',(⍕1↑⍴M),' label',((1≠1↑⍴M)/'s'),' sorted'[38]   →⍙1[39]  ⍙3:[40]  [41]  ⍝∇ Copyright (c) 1991 by Jim Weigang.  All rights reserved.[42]  ⍝∇ Unauthorized reproduction prohibited.    ∇