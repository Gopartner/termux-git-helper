

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

## instal package hasil build
```bash
dpkg -i output/git-helper_1.0.0_all.deb
```
<p>Jika ada error dependensi, jalankan:</p>
```bash
apt --fix-broken install
```


