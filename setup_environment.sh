#!/bin/bash
# setup_environment.sh — one-command setup for the supplementary code
# Usage:
#   bash setup_environment.sh
#
# Creates a virtual environment, installs pinned dependencies, and runs the
# self-test on shared_grokking.py. After this completes, you can run any
# script in code/.

set -e  # exit on first error

SUPP_ROOT="$(cd "$(dirname "$0")" && pwd)"
VENV_DIR="${SUPP_ROOT}/.venv"

echo "== Grokking supplementary — environment setup =="
echo "Working directory: ${SUPP_ROOT}"
echo

# Check Python
if ! command -v python3 >/dev/null 2>&1; then
    echo "ERROR: python3 not found. Please install Python 3.10+ first." >&2
    exit 1
fi
PY_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
echo "Python version: ${PY_VERSION}"

# Create venv
if [ ! -d "${VENV_DIR}" ]; then
    echo "Creating virtual environment at ${VENV_DIR}..."
    python3 -m venv "${VENV_DIR}"
else
    echo "Virtual environment already exists at ${VENV_DIR}"
fi

# Activate
# shellcheck source=/dev/null
source "${VENV_DIR}/bin/activate"

# Upgrade pip
pip install --upgrade pip --quiet

# Install requirements
echo
echo "Installing dependencies from REQUIREMENTS.txt..."
pip install -r "${SUPP_ROOT}/REQUIREMENTS.txt" --quiet

# Run smoke test
echo
echo "== Running smoke test on shared_grokking.py =="
cd "${SUPP_ROOT}/code"
python shared_grokking.py

echo
echo "== Setup complete =="
echo
echo "To activate the environment in future sessions:"
echo "    source ${VENV_DIR}/bin/activate"
echo
echo "To run the audit (verifies all paper claims against shipped data):"
echo "    cd ${SUPP_ROOT}/code"
echo "    python audit_repo.py"
echo
echo "To regenerate figures from shipped data:"
echo "    cd ${SUPP_ROOT}/code"
echo "    python make_figures_v3.py"
echo "    python make_fig5_v3.py"
echo "    python make_fig6_v3.py"
echo
echo "See README.md for the full reproduction guide."
