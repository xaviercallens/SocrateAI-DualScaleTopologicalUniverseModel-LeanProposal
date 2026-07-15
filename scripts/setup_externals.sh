#!/bin/bash
# Script to clone all external repositories as submodules

set -e  # Exit on error

echo "🔄 Setting up external repositories..."

# Clone Lean-QuantumInfo
if [ ! -d "external/Lean-QuantumInfo" ]; then
    echo "📥 Cloning Lean-QuantumInfo..."
    git submodule add https://github.com/Timeroot/Lean-QuantumInfo external/Lean-QuantumInfo
else
    echo "✅ Lean-QuantumInfo already exists. Updating..."
    cd external/Lean-QuantumInfo
    git pull origin main
    cd ../../
fi

# Clone Lean4PHYS
if [ ! -d "external/Lean4PHYS" ]; then
    echo "📥 Cloning Lean4PHYS..."
    git submodule add https://github.com/ShirleyLIYuxin/Lean4PHYS external/Lean4PHYS
else
    echo "✅ Lean4PHYS already exists. Updating..."
    cd external/Lean4PHYS
    git pull origin main
    cd ../../
fi

# Clone ml-string-landscape
if [ ! -d "external/ml-string-landscape" ]; then
    echo "📥 Cloning ml-string-landscape..."
    git submodule add https://github.com/AndreasSchachner/ml-string-landscape external/ml-string-landscape
else
    echo "✅ ml-string-landscape already exists. Updating..."
    cd external/ml-string-landscape
    git pull origin main
    cd ../../
fi

# Initialize and update all submodules
echo "🔄 Initializing and updating submodules..."
git submodule update --init --recursive

echo "✅ All external repositories set up successfully!"
