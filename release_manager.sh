#!/bin/bash

REPO="Gopartner/termux-git-helper"
OUTPUT_DIR="output"
DEB_FILE=$(ls $OUTPUT_DIR/*.deb 2>/dev/null | head -n 1)

if [ -z "$DEB_FILE" ]; then
    echo "🚨 Tidak ada file .deb ditemukan di folder $OUTPUT_DIR!"
    exit 1
fi

# Meminta pengguna memasukkan versi release
read -p "Masukkan versi release (contoh: v1.3.0) atau tekan [Enter] untuk otomatis: " INPUT_VERSION

if [ -z "$INPUT_VERSION" ]; then
    VERSION=$(basename "$DEB_FILE" | sed -E 's/git-helper_([0-9]+\.[0-9]+\.[0-9]+)_all.deb/\1/')
    RELEASE_TAG="v$VERSION"
else
    RELEASE_TAG="$INPUT_VERSION"
fi

echo "🔹 Versi release yang digunakan: $RELEASE_TAG"

function create_release() {
    echo "🚀 Membuat release baru: $RELEASE_TAG"

    # Meminta pengguna memasukkan deskripsi release
    read -p "Masukkan deskripsi release atau tekan [Enter] untuk menggunakan default: " RELEASE_NOTES

    if [ -z "$RELEASE_NOTES" ]; then
        RELEASE_NOTES="Release versi $RELEASE_TAG"
    fi

    # Cek apakah release sudah ada
    if gh release view "$RELEASE_TAG" --repo "$REPO" &>/dev/null; then
        echo "⚠️  Release $RELEASE_TAG sudah ada!"
        read -p "❓ Hapus release lama dan buat ulang? (y/n): " CONFIRM
        if [[ "$CONFIRM" == "y" ]]; then
            delete_release
            gh release create "$RELEASE_TAG" "$DEB_FILE" --repo "$REPO" --title "Git Helper $RELEASE_TAG" --notes "$RELEASE_NOTES"
        else
            echo "⏭ Melewati pembuatan release baru."
        fi
    else
        gh release create "$RELEASE_TAG" "$DEB_FILE" --repo "$REPO" --title "Git Helper $RELEASE_TAG" --notes "$RELEASE_NOTES"
    fi
}

function upload_to_release() {
    echo "📤 Mengunggah $DEB_FILE ke release $RELEASE_TAG..."

    # Periksa apakah file sudah ada di release
    if gh release view "$RELEASE_TAG" --repo "$REPO" | grep -q "$(basename "$DEB_FILE")"; then
        echo "⚠️  File sudah ada, menghapus file lama..."
        gh release delete-asset "$RELEASE_TAG" "$(basename "$DEB_FILE")" --repo "$REPO" --yes
    fi

    # Upload ulang file baru
    gh release upload "$RELEASE_TAG" "$DEB_FILE" --repo "$REPO"
}

function list_releases() {
    echo "📋 Daftar release yang tersedia di repository:"
    gh release list --repo "$REPO"
}

function delete_release() {
    echo "🚨 Menghapus release $RELEASE_TAG..."
    ATTEMPTS=0
    MAX_ATTEMPTS=3

    while (( ATTEMPTS < MAX_ATTEMPTS )); do
        gh release delete "$RELEASE_TAG" --repo "$REPO" --yes && break
        ATTEMPTS=$((ATTEMPTS+1))
        echo "⚠️  Gagal menghapus release, mencoba ulang ($ATTEMPTS/$MAX_ATTEMPTS)..."
        sleep 3
    done

    if (( ATTEMPTS == MAX_ATTEMPTS )); then
        echo "❌ Gagal menghapus release setelah $MAX_ATTEMPTS percobaan."
    else
        echo "✅ Release $RELEASE_TAG berhasil dihapus."
    fi
}

while true; do
    echo -e "\n📌 **Menu GitHub Release Manager**"
    echo "1. Buat release baru ($RELEASE_TAG)"
    echo "2. Upload package ke release ($RELEASE_TAG)"
    echo "3. Lihat daftar release"
    echo "4. Hapus release ($RELEASE_TAG)"
    echo "5. Keluar"
    read -p "Pilih opsi [1-5]: " OPTION

    case $OPTION in
        1) create_release ;;
        2) upload_to_release ;;
        3) list_releases ;;
        4) delete_release ;;
        5) echo "✅ Selesai!"; exit 0 ;;
        *) echo "❌ Pilihan tidak valid!";;
    esac
done

