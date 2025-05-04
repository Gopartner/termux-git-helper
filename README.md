## kode untuk "usr/bin/git-helper"
```bash
#!/bin/bash
SCRIPT_PATH="/usr/share/git-helper/git-helper.sh"

if [[ -f "$SCRIPT_PATH" ]]; then
    bash "$SCRIPT_PATH"
else
    echo "⚠️  File git-helper.sh tidak ditemukan!"
fi
```
<p>berikan izin</p>
```bash
chmod +x app/usr/bin/git-helper
```

## izin script
```bash
chmod +x app/usr/share/git-helper/git-helper.sh
```

## dpkg-deb membutuhkan izin antara 0755 dan 0775.
<p>izin sudah di set pada Makefile</p>
```bash
chmod 0755 app/DEBIAN
chmod 0555 app/DEBIAN/postinst
chmod 0555 app/DEBIAN/prerm
```
## build dengan:
```bash
make
```
<p>atau dengan perintah ini</p>
```bash
dpkg-deb --build app
```
## Tes git
```bash
# Buat branch pengembangan
git checkout -b main master
git push origin main

# Kerja di main
git checkout main
# edit + commit + push

# Setelah fitur stabil
git checkout master
git merge main
git push origin master
```
## pada branch penhembang:
```bash
git checkout main             # pastikan lagi sudah di 'main'
# (edit file sesuai fitur kamu)
git add .                     # stage semua perubahan
git commit -m "Tambah fitur baru di main"
git push                      # push ke origin/main
```
## Merge ke master Jika Sudah Stabil
```bash
git checkout master           # pindah ke branch master
git pull origin master        # pastikan up to date
git merge main                # gabungkan perubahan dari main
git push origin master        # push ke remote master
```
## ok bro


