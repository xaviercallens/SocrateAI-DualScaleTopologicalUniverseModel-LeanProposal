# Lean-QuantumInfo Submodule

**This directory is a Git submodule.**

## 📌 About
[Lean-QuantumInfo](https://github.com/Timeroot/Lean-QuantumInfo) is a repository for **quantum information theory formalized in Lean 4**. It provides:
- **Polynomial algebra** (`Mathlib.Algebra.Polynomial`)
- **Linear algebra** (Hilbert spaces, operators)
- **Proofs of quantum theorems** (Holevo’s theorem, Strong Subadditivity)

This repository has been **merged into Physlib** (part of the [leanprover-community](https://github.com/leanprover-community)), but we keep it as a submodule for backward compatibility.

---

## 🔄 How to Set Up

If this directory is empty, run:
```bash
cd external
git submodule update --init --recursive
```

---

## 📚 Usage in This Project

This submodule is used for:
1. **Formalizing Picard-Fuchs ODEs** (S12/S21 vs. Cooper s7/s10) in `Agora/Geometry/FTheoryFibration.lean`.
2. **Proving moduli stabilization** (Theorem 2) in `Agora/Swampland/DualScaleStability.lean`.
3. **Modeling 7-brane interactions** using operator algebras.

---

## 📜 License
MIT License. See [LICENSE](https://github.com/Timeroot/Lean-QuantumInfo/blob/main/LICENSE) for details.
