#!/bin/bash

# Warna ANSI
CYAN='\e[96m'
GREEN='\e[92m'
YELLOW='\e[93m'
RED='\e[91m'
RESET='\e[0m'

# Baca metadata dari info.prop dengan memastikan semua variabel ada
if [[ -f "info.prop" ]]; then
    while IFS="=" read -r key value; do
        key=$(echo "$key" | tr -d ' ')
        value=$(echo "$value" | sed 's/^[ \t]*//;s/[ \t]*$//')
        declare "$key=$value"
    done < info.prop
else
    name="Git Helper"
    version="Unknown"
    author="Unknown"
    description="Tidak ada deskripsi."
    website="Tidak tersedia"
    donation="Tidak tersedia"
fi

# Fungsi untuk menampilkan perintah dengan warna dan konfirmasi salin
show_command() {
    echo -e "\n${YELLOW}📌 Perintah:${RESET}"
    echo -e "${CYAN}$1${RESET}"

    # Konfirmasi untuk menyalin perintah ke clipboard
    read -p "❓ Salin perintah ke clipboard? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        if command -v termux-clipboard-set >/dev/null; then
            echo -n "$1" | termux-clipboard-set
            echo -e "\n${GREEN}✅ Perintah telah disalin ke clipboard!${RESET}"
        else
            echo -e "\n${RED}⚠️ Clipboard tidak tersedia di perangkat ini.${RESET}"
        fi
    else
        echo -e "\n${RED}❌ Perintah tidak disalin.${RESET}"
    fi

    echo -e "\nTekan ENTER untuk kembali ke menu..."
    read
}

# Menu utama
while true; do
    clear
    echo -e "${CYAN}=========================================${RESET}"
    echo -e "   ${GREEN}${name} 🚀 (v${version})${RESET}   "
    echo -e "   ${YELLOW}by ${author}${RESET}   "
    echo -e "${CYAN}=========================================${RESET}"
    echo -e "${YELLOW}📖 Deskripsi :${RESET} ${description}"
    echo -e "${YELLOW}🌍 Website   :${RESET} ${website}"
    echo -e "${YELLOW}💰 Donasi    :${RESET} ${donation}"
    echo -e "${CYAN}=========================================${RESET}"
    echo -e " ${YELLOW}1)${RESET} Inisialisasi Git"
    echo -e " ${YELLOW}2)${RESET} Konfigurasi Git"
    echo -e " ${YELLOW}3)${RESET} Menyimpan Perubahan"
    echo -e " ${YELLOW}4)${RESET} Remote Repository"
    echo -e " ${YELLOW}5)${RESET} Branching"
    echo -e " ${YELLOW}6)${RESET} Sinkronisasi"
    echo -e " ${YELLOW}7)${RESET} Cek Status & Log"
    echo -e " ${YELLOW}8)${RESET} Remote GitHub/GitLab"
    echo -e " ${YELLOW}9)${RESET} Tentang Git Helper"
    echo -e " ${YELLOW}10)${RESET} Keluar"
    echo -e "${CYAN}=========================================${RESET}"
    read -p "Pilih menu: " choice

    case $choice in
        1) clear
           echo -e "${GREEN}🔹 Inisialisasi Git${RESET}"
           show_command "git init"
           ;;
        2) clear
           echo -e "${GREEN}🔹 Konfigurasi Git${RESET}"
           show_command "git config --global user.name 'Nama Anda' && git config --global user.email 'email@example.com'"
           ;;
        3) clear
           echo -e "${GREEN}🔹 Menyimpan Perubahan${RESET}"
           show_command "git add . && git commit -m 'Pesan commit'"
           ;;
        4) clear
           echo -e "${GREEN}🔹 Remote Repository${RESET}"
           show_command "git remote add origin https://github.com/username/repo.git && git push -u origin main"
           ;;
        5) clear
           echo -e "${GREEN}🔹 Branching${RESET}"
           show_command "git checkout -b nama-branch && git push -u origin nama-branch"
           ;;
        6) clear
           echo -e "${GREEN}🔹 Sinkronisasi${RESET}"
           show_command "git pull origin main && git push origin main"
           ;;
        7) clear
           echo -e "${GREEN}🔹 Cek Status & Log${RESET}"
           show_command "git status && git log --oneline --graph --all"
           ;;
        8) clear
           echo -e "${GREEN}🔹 Remote GitHub/GitLab${RESET}"
           echo -e "Pilihan menu remote GitHub/GitLab telah tersedia di versi sebelumnya."
           sleep 2
           ;;
        9) clear
           echo -e "${GREEN}🔹 Tentang Git Helper${RESET}"
           echo -e "${YELLOW}Nama       :${RESET} ${name}"
           echo -e "${YELLOW}Versi      :${RESET} ${version}"
           echo -e "${YELLOW}Author     :${RESET} ${author}"
           echo -e "${YELLOW}Deskripsi  :${RESET} ${description}"
           echo -e "${YELLOW}Website    :${RESET} ${website}"
           echo -e "${YELLOW}Donasi     :${RESET} ${donation}"
           echo -e "\nTekan ENTER untuk kembali ke menu..."
           read
           ;;
        10) echo -e "${RED}👋 Keluar...${RESET}"
            exit 0
            ;;
        *) echo -e "${RED}⚠️ Pilihan tidak valid!${RESET}"
           sleep 1
           ;;
    esac
done

