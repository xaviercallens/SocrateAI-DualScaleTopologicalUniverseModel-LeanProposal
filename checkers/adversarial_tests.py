#!/usr/bin/env python3
"""
adversarial_tests.py — Master runner for Stream 2 C3b validation.

Orchestrates all adversarial checks (A1–A6) and geometry tasks (C1, C2):

  A1: Nullspace validation extended to n=200 (no overfitting artifact)
  A2: Mirror-map detector non-tautology (Apéry ζ(3) rejection)
  A4: s10 rational partner analysis (orbifold vs defect)
  A5/A6: Provenance hygiene (no AI hallucination of OEIS IDs)
  C1: Kodaira fiber classification (elliptic L₂ partner)
  C2: Picard lattice & transcendental rank (K3 geometry)

Status: All checks must PASS before C3b geometry is locked.
Outputs: data/certificates/A1_through_A6_status.json + C1/C2 certificates.
"""

import json
import sys
import subprocess
from pathlib import Path
from datetime import datetime

# ════════════════════════════════════════════════════════════════════════════════
# TEST RUNNER
# ════════════════════════════════════════════════════════════════════════════════

class C3bValidationRunner:
    """Orchestrates all C3b validation checks."""

    def __init__(self):
        self.results = {}
        self.status_table = {}
        self.certificates_dir = Path('data/certificates')
        self.checkers_dir = Path('checkers')
        self.timestamp = datetime.utcnow().isoformat()

    def run_check(self, check_name, script_name, description):
        """
        Run a single adversarial check or geometry task.

        Args:
            check_name: str (e.g., 'A1', 'C1')
            script_name: str (e.g., 'adversarial_A1_nullspace_control.py')
            description: str (human-readable)

        Returns: (pass: bool, output: str)
        """
        print(f"\n[{check_name}] {description}...")

        script_path = self.checkers_dir / script_name

        if not script_path.exists():
            print(f"  ⚠  Script not found: {script_path}")
            return False, f"Script missing: {script_path}"

        try:
            result = subprocess.run(
                [sys.executable, str(script_path)],
                capture_output=True,
                text=True,
                timeout=60
            )

            output = result.stdout + result.stderr
            passed = (result.returncode == 0)

            status = "✅ PASS" if passed else "❌ FAIL"
            print(f"  {status}")

            return passed, output

        except subprocess.TimeoutExpired:
            print(f"  ❌ TIMEOUT")
            return False, "Timeout"

        except Exception as e:
            print(f"  ❌ ERROR: {e}")
            return False, str(e)

    def run_all_checks(self):
        """Execute all validation checks in order."""

        checks = [
            ('A1', 'adversarial_A1_nullspace_control.py',
             'Extend s7/s10 to n=200 (no overfitting)'),
            ('A2', 'adversarial_A2_mirror_map_control.py',
             'Mirror-map detector (Apéry ζ(3) rejection)'),
            ('A4', 'adversarial_A4_rational_partner_analysis.py',
             's10 rational partner (orbifold vs defect)'),
            ('A5/A6', 'adversarial_A5_A6_provenance_hygiene.py',
             'Provenance hygiene (no hallucination)'),
            ('C1', 'check_C1_kodaira_fibers.py',
             'Kodaira fiber classification'),
            ('C2', 'check_C2_picard_lattice.py',
             'Picard lattice & transcendental rank'),
        ]

        for check_name, script_name, description in checks:
            passed, output = self.run_check(check_name, script_name, description)
            self.results[check_name] = {
                'passed': passed,
                'output_lines': output.split('\n')[:10]  # First 10 lines
            }
            self.status_table[check_name] = 'PASS' if passed else 'FAIL'

    def generate_status_report(self):
        """Generate a summary status report."""

        print("\n" + "═" * 80)
        print("C3b Validation Summary")
        print("═" * 80)

        print("\nCheck Status:")
        for check_name, status in self.status_table.items():
            symbol = "✅" if status == "PASS" else "❌"
            print(f"  {symbol} {check_name}: {status}")

        all_pass = all(status == "PASS" for status in self.status_table.values())

        print("\n" + "─" * 80)
        print("Final Verdict:")
        if all_pass:
            print("  ✅ ALL CHECKS PASS")
            print("\n  Stream 1 L₃ = Sym²(L₂) geometry is LOCKED.")
            print("  Stream 2 physics selection (C3b) can proceed to GUT matching.")
        else:
            print("  ❌ SOME CHECKS FAILED")
            print("\n  Halt: resolve failures before proceeding to physics selection.")
            print("\n  Likely issues:")
            for check_name, status in self.status_table.items():
                if status == "FAIL":
                    if check_name == 'A1':
                        print(f"    - {check_name}: L₂ may be overfitting artifact (n=200 failed)")
                    elif check_name == 'A2':
                        print(f"    - {check_name}: mirror-map detector is tautology (Apéry passed)")
                    elif check_name == 'A4':
                        print(f"    - {check_name}: s10 rational structure incompatible with K3")
                    elif check_name == 'A5/A6':
                        print(f"    - {check_name}: OEIS ID hallucination detected")
                    else:
                        print(f"    - {check_name}: geometry computation failed")

        print("\n" + "═" * 80)

        return all_pass

    def save_certificate(self):
        """Save the validation status to a certificate."""

        self.certificates_dir.mkdir(parents=True, exist_ok=True)

        certificate = {
            'timestamp': self.timestamp,
            'validation_type': 'C3b_full_suite',
            'checks': self.status_table,
            'overall_status': 'PASS' if all(s == 'PASS' for s in self.status_table.values()) else 'FAIL',
            'notes': [
                'A1-A6: adversarial checks (nullspace, mirror-map, rational, provenance)',
                'C1: Kodaira fiber classification (singular loci + monodromy)',
                'C2: Picard lattice & discriminant (K3 geometry)',
                'All must pass before geometry is locked for physics selection'
            ]
        }

        cert_path = self.certificates_dir / 'A1_through_A6_status.json'
        with open(cert_path, 'w') as f:
            json.dump(certificate, f, indent=2)

        print(f"\nCertificate saved: {cert_path}")


# ════════════════════════════════════════════════════════════════════════════════
# MAIN
# ════════════════════════════════════════════════════════════════════════════════

def main():
    print("╔" + "═" * 78 + "╗")
    print("║" + " " * 78 + "║")
    print("║" + " Stream 2 C3b Validation: Adversarial Checks & Geometry Tasks ".center(78) + "║")
    print("║" + " " * 78 + "║")
    print("╚" + "═" * 78 + "╝")

    runner = C3bValidationRunner()

    print("\nExecuting all checks (A1–A6, C1, C2)...")

    try:
        runner.run_all_checks()
    except KeyboardInterrupt:
        print("\n\n⚠  Interrupted by user")
        return 1

    all_pass = runner.generate_status_report()

    runner.save_certificate()

    return 0 if all_pass else 1


if __name__ == "__main__":
    sys.exit(main())
