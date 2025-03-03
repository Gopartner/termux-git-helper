#!/bin/bash

set -e  # Hentikan skrip jika ada error

# Direktori proyek
PROJECT_DIR="$HOME/termux-git-helper"
BUILD_DIR="$PROJECT_DIR/build"

echo "🛠 Membersihkan build sebelumnya..."
rm -rf "$BUILD_DIR" "$PROJECT_DIR/output" "$PROJECT_DIR/repo"

echo "📂 Membuat direktori build..."
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo "🔧 Menjalankan CMake..."
cmake ..

echo "⚙️  Membangun paket .deb..."
make build-deb

echo "📦 Memperbarui repository APT..."
make update-repo

echo "🌍 Mengunggah repository APT ke GitHub (branch master)..."
make update-repo-git

echo "🚀 Mengunggah package ke GitHub Releases..."
make update-release

echo "✅ Semua tugas selesai!"

