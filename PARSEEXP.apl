﻿    ∇ Z←L PARSEEXP A;T;Q;Y;B;W;A;V;a;b;c;d;e;f;g;h;i;j;k;l;m;n;o;p;q;r;s;t;u;v;w;x;y;z;X;D;C;O[1]   ⍝Subroutine of SCRIPT, parse expression ⍵ for SCRIPT_EXP with local variables 1⊃⍺ and options 2⊃⍺[2]   ⍝B. Compton, 30 Sep-1 Oct 2014[3]   ⍝2 Oct 2014: rewrite to allow grid names in expression & do macro replacement[4]   ⍝13 May 2016: don't fail when V is empty[5]   ⍝23 Jan 2016: also don't fail for empty C (no local variables)[6]   [7]   [8]   [9]    L O ← L[10]   ⎕←'Parsing expression: ',X←3⊃A[11]   X←MACRO X                                      ⍝Macro replacement[12]  [13]   D←'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_:\'  ⍝Characters in identifiers (local varibles and grid names)[14]   X←(1,1↓(~X∊'0123456789')^T≠2,¯1↓T←X∊D)⊂X       ⍝Enclose tokens[15]   B←(^/¨X∊¨⊂D)^~(1↑¨X)∊'0123456789'              ⍝Mark identifiers[16]   W←'ln in min max round floor ceiling abs mod isnull setnull if'           ⍝Reserved words[17]   B←B^~X∊FRDBL¨↓MATRIFY W                        ⍝Identifiers that are not reserved words - these are grids or local variables[18]   C←B\(B/X)∊FRDBL¨↓0 1↓L                         ⍝Mark local variables[19]  [20]   :if 1∊C                                        ⍝If any local variables,[21]      Q←MACRO¨⍎¨'∆',¨C/X                          ⍝   Do macro replacement in local variables[22]      X[C/⍳⍴X]←Q                                  ⍝   And replace expression tokens with values of local variables[23]      B←B^~C\~(^/¨Q∊¨⊂D)^~(1↑¨Q)∊'0123456789'     ⍝Add local variables that are identifiers to grid list[24]   :end[25]   W←B/X                                          ⍝Grid names to append to call[26]   X[B/⍳⍴X]←V←↓((+/B),1)⍴'abcdefghijklmnopqrstuvwxyz'  ⍝Replace grid names with a b c variable names[27]   X←⍕⊃,/X[28]  [29]   Q←'.*.×./.DIVIDE.^.*.ln.⍟.<>.≠.>=.≥.<=.≤.in.∊.|.∨.¦.∨.&.^.min.⌊.max.⌈.round.ROUND.floor.⌊.ceiling.⌈.abs.|.mod.|.isnull.ISNULL.setnull.SETNULL.if.IF'[30]   Q←Q WORDREPL LOWTOHIX X                        ⍝Replace keywords with APL functions (will do this for real in SCRIPT_EXP, as we're passing this through text files)[31]   :if ~0∊⍴V[32]      V←⍎¨V,¨⊂'←1'                                ⍝Set all variables used to 1[33]   :end[34]   →(1≡Z←1⊃CATCH Q)/0                             ⍝execute to look for errors & return 1 if it's bad[35]  [36]   A[3]←⊂'''',X,''''                              ⍝Put call together[37]   A←A,W[38]   Z←(pathZ PATHQUOTEMAC 1⊃A),' ',(⍕blocksize),' ',O,' ',(⊃,/' ',¨A[2 3]),(DISCLOSEALL ' ',¨(⊂pathZ) PATHQUOTEMAC¨3↓A),' ''',mask,''''    ∇