﻿    ∇ P CHECKFILE F;T[1]   ⍝Look for file ⍵ (default is .par); warn if missing.  Use model path unless path is supplied in ⍺[2]   [3]   [4]    ⍎(0=⎕NC'P')/'P←pathI'[5]    →(0∊⍴FRDBL F)/0        ⍝No warning if empty string[6]    'Missing (or locked) parameter table:' WARN (~IFEXISTS T)/T←P PATH F EXT 'par'    ∇