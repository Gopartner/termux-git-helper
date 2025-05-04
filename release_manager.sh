#!/bin/bash
set -e

# Konfigurasi
REPO="Gopartner/termux-git-helper"
OUTPUT_DIR="output"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

# Cek apakah gh CLI sudah login
if ! gh auth status &>/dev/null; then
    echo -e "${RED}❌ GitHub CLI belum login! Jalankan: gh auth login${RESET}"
    exit 1
fi

# Ambil file .deb terbaru
DEB_FILE=$(ls -t "$OUTPUT_DIR"/*.deb 2>/dev/null | head -n 1)

if [ -z "$DEB_FILE" ]; then
    echo -e "${RED}🚨 Tidak ada file .deb ditemukan di folder $OUTPUT_DIR!${RESET}"
    exit 1
fi

# Validasi ekstensi
if [[ "$DEB_FILE" != *.deb ]]; then
    echo -e "${RED}❌ File bukan .deb: $DEB_FILE${RESET}"
    exit 1
fi

# Versi release
read -p "Masukkan versi release (contoh: v1.3.0) atau tekan [Enter] untuk otomatis: " INPUT_VERSION

if [ -z "$INPUT_VERSION" ]; then
    VERSION=$(basename "$DEB_FILE" | sed -E 's/git-helper_([0-9]+\.[0-9]+\.[0-9]+)_all.deb/\1/')
    RELEASE_TAG="v$VERSION"
else
    RELEASE_TAG="$INPUT_VERSION"
fi

echo -e "${YELLOW}🔹 Versi release yang digunakan: $RELEASE_TAG${RESET}"

# Fungsi membuat release baru
function create_release() {
    echo -e "${GREEN}🚀 Membuat release baru: $RELEASE_TAG${RESET}"

    read -p "Masukkan deskripsi release atau tekan [Enter] untuk menggunakan default: " RELEASE_NOTES
    [ -z "$RELEASE_NOTES" ] && RELEASE_NOTES="Release versi $RELEASE_TAG"

    if gh release view "$RELEASE_TAG" --repo "$REPO" &>/dev/null; then
        echo -e "${YELLOW}⚠️  Release $RELEASE_TAG sudah ada!${RESET}"
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

# Fungsi upload ulang file .deb
function upload_to_release() {
    echo -e "${GREEN}📤 Mengunggah $DEB_FILE ke release $RELEASE_TAG...${RESET}"

    if gh release view "$RELEASE_TAG" --repo "$REPO" | grep -q "$(basename "$DEB_FILE")"; then
        echo -e "${YELLOW}⚠️  File sudah ada, menghapus file lama...${RESET}"
        gh release delete-asset "$RELEASE_TAG" "$(basename "$DEB_FILE")" --repo "$REPO" --yes
    fi

    gh release upload "$RELEASE_TAG" "$DEB_FILE" --repo "$REPO"
}

# Fungsi lihat daftar release
function list_releases() {
    echo -e "${YELLOW}📋 Daftar release di $REPO:${RESET}"
    gh release list --repo "$REPO"
}

# Fungsi hapus release
function delete_release() {
    echo -e "${RED}🚨 Menghapus release $RELEASE_TAG...${RESET}"
    ATTEMPTS=0
    MAX_ATTEMPTS=3

    while (( ATTEMPTS < MAX_ATTEMPTS )); do
        gh release delete "$RELEASE_TAG" --repo "$REPO" --yes && break
        ATTEMPTS=$((ATTEMPTS+1))
        echo -e "${YELLOW}⚠️  Gagal menghapus release, mencoba ulang ($ATTEMPTS/$MAX_ATTEMPTS)...${RESET}"
        sleep 3
    done

    if (( ATTEMPTS == MAX_ATTEMPTS )); then
        echo -e "${RED}❌ Gagal menghapus release setelah $MAX_ATTEMPTS percobaan.${RESET}"
    else
        echo -e "${GREEN}✅ Release $RELEASE_TAG berhasil dihapus.${RESET}"
    fi
}

# Menu interaktif
while true; do
    echo -e "\n${YELLOW}📌 Menu GitHub Release Manager${RESET}"
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
        5) echo -e "${GREEN}✅ Selesai!${RESET}"; exit 0 ;;
        *) echo -e "${RED}❌ Pilihan tidak valid!${RESET}";;
    esac
done

