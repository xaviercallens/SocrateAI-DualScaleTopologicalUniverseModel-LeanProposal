# Contributing to SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal

We welcome contributions from the community! Here’s how you can help:

---

## 📌 How to Contribute

### 1. **Fork the Repository**
   - Fork this repository to your GitHub account.
   - Clone your fork locally:
     ```bash
     git clone https://github.com/YOUR_USERNAME/SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal.git
     cd SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal
     ```

### 2. **Set Up the Environment**
   - Install [Lean 4](https://leanprover.github.io/lean4_doc/basics/first_steps.html) and [Mathlib](https://leanprover-community.github.io/mathlib4_doc/).
   - Set up external dependencies:
     ```bash
     ./scripts/setup_externals.sh
     ./scripts/download_zenodo.sh
     ```

### 3. **Make Your Changes**
   - Add new Lean 4 proofs to the `Agora/` directory.
   - Add new ML tools to the `Agora/ML/` directory.
   - Update documentation in the `docs/` directory.

### 4. **Test Your Changes**
   - Build the Lean 4 proofs:
     ```bash
     lake build
     ```
   - Run ML scripts:
     ```bash
     python Agora/ML/Optimize_Moduli.py
     jupyter notebook Agora/ML/AutoEvolve_PicardFuchs.ipynb
     ```

### 5. **Commit and Push**
   - Commit your changes with a descriptive message:
     ```bash
     git add .
     git commit -m "Your descriptive commit message"
     git push origin main
     ```
   - Open a **Pull Request** to the main repository.

---

## 🎯 Contribution Guidelines

### **Lean 4 Contributions**
- Follow the [Mathlib style guide](https://leanprover-community.github.io/mathlib4_doc/contribute/style.html).
- Use `sorry` for incomplete proofs, but aim to fill them in.
- Add docstrings to all definitions and theorems.

### **Machine Learning Contributions**
- Use Python 3.8+ and the dependencies listed in `Agora/ML/requirements.txt`.
- Add comments to explain complex logic.
- Include example usage in Jupyter notebooks.

### **Documentation Contributions**
- Use Markdown for documentation.
- Keep explanations clear and concise.
- Link to relevant papers and resources.

---

## 📚 Code of Conduct

By participating in this project, you agree to abide by the [Code of Conduct](CODE_OF_CONDUCT.md).

---

## 🤝 Collaboration

- **Theoretical Physics**: Collaborate with Yu-Dai Tsai (Sheffield) for F-theory insights.
- **String Theory**: Work with Miranda Cheng (Amsterdam) or Ron Donagi (UPenn) for string compactifications.
- **Lean 4**: Engage with the [Mathlib community](https://github.com/leanprover-community/mathlib4) for formalization support.
- **Machine Learning**: Partner with Andreas Schachner for ML applications in string theory.

---

## 📧 Contact

For questions or discussions, open an issue or contact:
- **Xavier Callens**: [callensxavier@gmail.com](mailto:callensxavier@gmail.com)
- **GitHub Discussions**: [Discussions](https://github.com/xaviercallens/SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal/discussions)
