import Mathlib.Analysis.SpecialFunctions

namespace Agora.Phenomenology

/-- The Effective Coupling is boosted by the Chameleon mechanism near the Event Horizon -/
theorem chameleon_rescue_m87 (rho_b rho_crit alpha_bare : ℝ)
    (h_rho : rho_b > 1000 * rho_crit) (h_alpha : alpha_bare = 0.155) :
    alpha_bare * (rho_b / rho_crit)^(1/4) > 0.45 := by
  norm_num
  linarith
