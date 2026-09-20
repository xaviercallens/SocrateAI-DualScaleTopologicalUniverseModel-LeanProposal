/-
  Agora.lean
  Root namespace for the Agora (marketplace of ideas) module.
  Aggregates all submodules.
-/

import Agora.Sequences
import Agora.Geometry
import Agora.Phenomenology
import Agora.Swampland
import Agora.DualScaleMaster
-- LeanMaster dependency smoke test (added 2026-09-20). Imported here so that
-- `lake build Agora` exercises the dependency; see the module's header for why
-- it establishes no new mathematics.
import Agora.Bridge.LeanMasterK3
