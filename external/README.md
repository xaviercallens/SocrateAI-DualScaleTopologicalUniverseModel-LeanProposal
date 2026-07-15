# External Resources

This directory contains **submodules and downloaded resources** for the Dual-Scale Topological Universe Model.

---

## 📦 Submodules

### 1. [Lean-QuantumInfo](https://github.com/Timeroot/Lean-QuantumInfo)
- **Purpose**: Quantum information theory in Lean 4 (now part of [Physlib](https://github.com/leanprover-community/Physlib)).
- **Usage**: Provides polynomial algebra and quantum info tools for F-theory formalization.
- **Setup**:
  ```bash
  git submodule update --init --recursive
  ```

### 2. [Lean4PHYS](https://github.com/ShirleyLIYuxin/Lean4PHYS)
- **Purpose**: College-level physics formalization in Lean 4.
- **Usage**: Provides physics units and observables for cosmological predictions.
- **Setup**:
  ```bash
  git submodule update --init --recursive
  ```

### 3. [ml-string-landscape](https://github.com/AndreasSchachner/ml-string-landscape)
- **Purpose**: Machine learning for string landscape exploration.
- **Usage**: Provides ML tools for classifying Picard-Fuchs ODEs and optimizing moduli.
- **Setup**:
  ```bash
  git submodule update --init --recursive
  ```

---

## 📥 Zenodo Records

### 1. [Hilbert-Pólya Operator (10.5281/zenodo.20290893)](https://doi.org/10.5281/zenodo.20290893)
- **Purpose**: Formal Lean 4 verification of the Hilbert-Pólya operator.
- **Usage**: Template for formalizing F-theory geometries (Weierstrass model, discriminant locus).
- **Download**:
  ```bash
  ./scripts/download_zenodo.sh
  ```
- **Location**: `external/zenodo_20290893/`

---

## 🔄 How to Update

To update all submodules and external resources:

```bash
# Update submodules
git submodule update --remote --recursive

# Re-download Zenodo records (if needed)
./scripts/download_zenodo.sh
```

---

## 📚 License

Each external resource has its own license:
- **Lean-QuantumInfo**: MIT License
- **Lean4PHYS**: Apache-2.0 License
- **ml-string-landscape**: Apache-2.0 License
- **Hilbert-Pólya (Zenodo)**: Creative Commons Attribution 4.0 International

See the respective repositories/records for details.
