/-
  OpenGoals.lean
  Named open goals per CLAUDE.md §3: sorry is allowed only here and only for
  explicitly named, indexed lemmas that have been tried 3+ times or hit a
  fundamental blocker. When lake build OpenGoals succeeds with zero sorry,
  all named open goals have been discharged.

  NOTE: imports only Agora.Sequences (which compiles cleanly) to avoid
  dragging in broken pre-existing files until they are fixed.
-/

import Agora.Sequences
import OpenGoals.CooperRecurrences

namespace OpenGoals

-- Named open goals are defined in submodule files (e.g., OpenGoals.CooperRecurrences)

end OpenGoals
