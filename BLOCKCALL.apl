﻿    ∇ L BLOCKCALL M;block;noread;buffer;fileptr;test;loop;ifchat;firstblock;override_pars;gridname;exclude;example;mask;maskv;framework[1]   ⍝Call CAPS metric ⍵[1] for block ⍺, inputs ⍵[2], settings ⍵[3], results ⍵[4], buffer ⍵[5], include grid ⍵[6], systems ⍵[7], and optional override_pars file ⍵[8][2]   ⍝Metric call is (inputs) (settings) (results) METRIC (systems)[3]   ⍝B. Compton, 21 Jan 2009[4]   ⍝23 May 2011: modified to work with Anthill[5]   ⍝22 Jun 2011: pass in override_pars via a file[6]   ⍝11 Aug 2011: get override_pars first, for temporary model path[7]   ⍝31 Aug 2011: Call SETPATHS here, before setting override_pars![8]   ⍝23 Jan 2012: push override_pars into INIT_S; new scheme[9]   [10]  [11]   framework←'caps'[12]   M←8↑M,⊂''[13]   INITO 8⊃M[14]   block←L[15]   LOG (1⊃M),': Block ',(⍕block[4]),',',(⍕block[5]),(((block[7]≠0)/' of ',(⍕block[6]),',',⍕block[7])),(' (',(⍕block[11]),' of ',(⍕block[12]),')'),(aplc=1)/' (',(BLOCKIDS block[11]),')'[16]   ifchat←0[17]   ⍎FRDBL DEB⍕(BUILDPAR¨M[2 3 4]),(M[5]),(BUILDPAR M[6]),(1⊃M),' ''',(⊃M[7]),''''     ⍝Call metric    ∇