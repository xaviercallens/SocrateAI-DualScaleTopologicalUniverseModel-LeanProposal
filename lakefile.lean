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

require QuantumInfo from git
  "https://github.com/Timeroot/Lean-QuantumInfo.git"
  @"56e83a9288a3c616285038748e273b3c0e1a36bf"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git"
  @"3dffaf2f18b47d11948f6390838ea6f2ae662aaf"
