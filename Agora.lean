/-
  Agora.lean
  Root namespace for the Agora (marketplace of ideas) module.
  Aggregates all submodules.
-/

import Agora.Sequences
import Agora.Geometry
import Agora.Swampland
-- Quarantine (2026-09-21). Retained and compiled, but NOT a physics result and
-- not depended on by anything above; see Agora/Unverified.lean for what that means.
import Agora.Unverified
-- LeanMaster dependency smoke test (added 2026-09-20). Imported here so that
-- `lake build Agora` exercises the dependency; see the module's header for why
-- it establishes no new mathematics.
import Agora.Bridge.LeanMasterK3
