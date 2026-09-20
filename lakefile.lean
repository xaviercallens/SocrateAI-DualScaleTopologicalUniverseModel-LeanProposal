import Lake
open Lake DSL

package «SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal» {
  -- add any package configuration options here
}

lean_lib Agora {
  -- add any library configuration options here
}

lean_lib OpenGoals {
}

lean_lib Tests {
}

-- Mathlib pinned at tag v4.34.0-rc2 (commit 85e3a25e006c35636f0e53b0e9296caca2685bc0).
-- That tag's `lean-toolchain` must match this project's `lean-toolchain` exactly
-- (`leanprover/lean4:v4.34.0-rc2`), otherwise the upstream olean cache is unusable.
-- rc2 (not v4.34.0 final) is deliberate: it is the pin used by
-- SocrateAI-Scientific-Agora-LeanMaster, so the two projects share one olean cache
-- and LeanMaster's corpus stays importable from here without a second toolchain.
-- History: Lean v4.32.0 + mathlib commit 3dffaf2f18b47d11948f6390838ea6f2ae662aaf
-- until the 2026-09-20 migration (T0 decision; CLAUDE.md rule 1 amended in the same change).
require "leanprover-community" / "mathlib" @ git "v4.34.0-rc2"

-- REMOVED 2026-09-20 (Lean 4.34.0-rc2 migration): the `QuantumInfo` require
-- (Timeroot/Lean-QuantumInfo @ 56e83a9288a3c616285038748e273b3c0e1a36bf).
-- No file under `Agora/`, `OpenGoals/` or `Tests/` ever imported it — verified by
-- `grep -rn QuantumInfo --include=*.lean` before removal — so dropping it loses no
-- result. It was pinned to a Lean-4.32-era commit and would otherwise have blocked
-- the toolchain bump. The vendored source stays in `external/Lean-QuantumInfo`
-- (git submodule) for reference; it is simply no longer a build dependency.
