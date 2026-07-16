#!/bin/bash
# Script to download the Hilbert-Pólya Operator from Zenodo

set -e  # Exit on error

echo "🔄 Downloading Zenodo record (Hilbert-Pólya Operator)..."

# Create directory for Zenodo record
mkdir -p external/zenodo_20290893

# Download the Zenodo record
if [ ! -f "external/zenodo_20290893/omega-pcf.zip" ]; then
    echo "📥 Downloading omega-pcf.zip..."
    wget -O external/zenodo_20290893/omega-pcf.zip https://zenodo.org/record/20290893/files/omega-pcf/01-hilbert-polya-v2.4.1.zip
else
    echo "✅ omega-pcf.zip already exists. Skipping download."
fi

# Unzip the file
if [ ! -d "external/zenodo_20290893/omega-pcf" ]; then
    echo "📦 Unzipping omega-pcf.zip..."
    unzip external/zenodo_20290893/omega-pcf.zip -d external/zenodo_20290893/
else
    echo "✅ omega-pcf directory already exists. Skipping unzip."
fi

echo "✅ Zenodo record downloaded and extracted successfully!"
