#!/bin/bash

# Warna ANSI
CYAN='\e[96m'
GREEN='\e[92m'
YELLOW='\e[93m'
RED='\e[91m'
RESET='\e[0m'

# Fungsi membaca metadata dari info.prop
read_metadata() {
    if [[ -f "info.prop" ]]; then
        while IFS='=' read -r key value; do
            case "$key" in
                name) NAME="$value" ;;
                version) VERSION="$value" ;;
                author) AUTHOR="$value" ;;
                description) DESCRIPTION="$value" ;;
                website) WEBSITE="$value" ;;
                donation) DONATION="$value" ;;
            esac
        done < "info.prop"
    else
        echo -e "${RED}⚠️ File info.prop tidak ditemukan!${RESET}"
        exit 1
    fi
}

# Fungsi untuk menyalin perintah ke clipboard
copy_command() {
    local command="$1"
    read -p "📋 Salin perintah ke clipboard? (y/n): " confirm
    if [[ $confirm == "y" || $confirm == "Y" ]]; then
        if command -v termux-clipboard-set &>/dev/null; then
            echo -n "$command" | termux-clipboard-set
            echo -e "${GREEN}✅ Perintah disalin ke clipboard!${RESET}"
        elif command -v xclip &>/dev/null; then
            echo -n "$command" | xclip -selection clipboard
            echo -e "${GREEN}✅ Perintah disalin ke clipboard!${RESET}"
        else
            echo -e "${RED}⚠️ Clipboard tidak tersedia! Install xclip (Linux) atau gunakan Termux.${RESET}"
        fi
    fi
}

# Baca metadata dari info.prop
read_metadata

# Menu utama
while true; do
    clear
    echo -e "${CYAN}=========================================${RESET}"
    echo -e "   ${GREEN}$NAME 🚀 (v$VERSION)${RESET}"
    echo -e "   by ${YELLOW}$AUTHOR${RESET}"
    echo -e "${CYAN}=========================================${RESET}"
    echo -e "${YELLOW}📖 Deskripsi :${RESET} $DESCRIPTION"
    echo -e "${YELLOW}🌍 Website   :${RESET} $WEBSITE"
    echo -e "${YELLOW}💰 Donasi    :${RESET} $DONATION"
    echo -e "${CYAN}=========================================${RESET}"
    echo -e " ${YELLOW}1)${RESET} Inisialisasi Git"
    echo -e " ${YELLOW}2)${RESET} Konfigurasi Git"
    echo -e " ${YELLOW}3)${RESET} Menyimpan Perubahan"
    echo -e " ${YELLOW}4)${RESET} Remote Repository"
    echo -e " ${YELLOW}5)${RESET} Branching"
    echo -e " ${YELLOW}6)${RESET} Sinkronisasi"
    echo -e " ${YELLOW}7)${RESET} Cek Status & Log"
    echo -e " ${YELLOW}8)${RESET} Remote GitHub/GitLab"
    echo -e " ${YELLOW}9)${RESET} Git Rebase"
    echo -e " ${YELLOW}10)${RESET} Keluar"
    echo -e "${CYAN}=========================================${RESET}"
    read -p "Pilih menu: " choice

    case $choice in
        1) 
            command="git init"
            echo -e "\n${GREEN}📌 Inisialisasi Git:${RESET}"
            echo -e "${YELLOW}$command${RESET}"
            copy_command "$command"
            ;;
        2) 
            command="git config --global user.name 'Nama Anda'\ngit config --global user.email 'email@example.com'"
            echo -e "\n${GREEN}📌 Konfigurasi Git:${RESET}"
            echo -e "${YELLOW}git config --global user.name 'Nama Anda'${RESET}"
            echo -e "${YELLOW}git config --global user.email 'email@example.com'${RESET}"
            copy_command "$command"
            ;;
        3) 
            command="git add .\ngit commit -m 'Pesan commit'"
            echo -e "\n${GREEN}📌 Menyimpan Perubahan:${RESET}"
            echo -e "${YELLOW}git add .${RESET}"
            echo -e "${YELLOW}git commit -m 'Pesan commit'${RESET}"
            copy_command "$command"
            ;;
        4) 
            command="git remote add origin https://github.com/username/repo.git\ngit push -u origin main"
            echo -e "\n${GREEN}📌 Remote Repository:${RESET}"
            echo -e "${YELLOW}git remote add origin https://github.com/username/repo.git${RESET}"
            echo -e "${YELLOW}git push -u origin main${RESET}"
            copy_command "$command"
            ;;
        5) 
            command="git checkout -b nama-branch\ngit push -u origin nama-branch"
            echo -e "\n${GREEN}📌 Branching:${RESET}"
            echo -e "${YELLOW}git checkout -b nama-branch${RESET}"
            echo -e "${YELLOW}git push -u origin nama-branch${RESET}"
            copy_command "$command"
            ;;
        6) 
            command="git pull origin main\ngit push origin main"
            echo -e "\n${GREEN}📌 Sinkronisasi:${RESET}"
            echo -e "${YELLOW}git pull origin main${RESET}"
            echo -e "${YELLOW}git push origin main${RESET}"
            copy_command "$command"
            ;;
        7) 
            command="git status\ngit log --oneline --graph --all"
            echo -e "\n${GREEN}📌 Cek Status & Log:${RESET}"
            echo -e "${YELLOW}git status${RESET}"
            echo -e "${YELLOW}git log --oneline --graph --all${RESET}"
            copy_command "$command"
            ;;
        8) 
            command="git remote -v"
            echo -e "\n${GREEN}📌 Remote GitHub/GitLab:${RESET}"
            echo -e "${YELLOW}$command${RESET}"
            copy_command "$command"
            ;;
        9) 
            command="git rebase -i HEAD~3\ngit rebase origin/main\ngit rebase --abort"
            echo -e "\n${GREEN}📌 Git Rebase:${RESET}"
            echo -e "${YELLOW}git rebase -i HEAD~3${RESET}  # Edit, hapus, atau gabungkan commit"
            echo -e "${YELLOW}git rebase origin/main${RESET}  # Rebase branch utama"
            echo -e "${YELLOW}git rebase --abort${RESET}  # Batalkan rebase"
            copy_command "$command"
            ;;
        10) 
            echo -e "${RED}👋 Keluar...${RESET}"
            exit 0
            ;;
        *) 
            echo -e "${RED}⚠️ Pilihan tidak valid!${RESET}"
            sleep 1
            ;;
    esac
done

