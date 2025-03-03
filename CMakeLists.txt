cmake_minimum_required(VERSION 3.10)
project(GitHelper NONE)

set(PKG_NAME "git-helper")
set(PKG_VERSION "1.0.0")
set(PKG_ARCH "all")
set(PKG_DIR "${CMAKE_BINARY_DIR}/pkg")
set(OUTPUT_DIR "${CMAKE_SOURCE_DIR}/output")
set(OUTPUT_FILE "${OUTPUT_DIR}/${PKG_NAME}_${PKG_VERSION}_${PKG_ARCH}.deb")
set(REPO_DIR "${CMAKE_SOURCE_DIR}/repo")

# Pastikan direktori output dan repo ada
file(MAKE_DIRECTORY ${OUTPUT_DIR})
file(MAKE_DIRECTORY ${REPO_DIR})

# Salin file ke struktur paket
file(COPY ${CMAKE_SOURCE_DIR}/app/ DESTINATION ${PKG_DIR})

# Perintah untuk membangun paket .deb
add_custom_target(build-deb ALL
    COMMAND dpkg-deb --build ${PKG_DIR} ${OUTPUT_FILE}
    COMMENT "Membangun paket Debian: ${OUTPUT_FILE}"
)

# Membuat repository APT menggunakan apt-ftparchive
add_custom_target(update-repo
    COMMAND rm -f ${REPO_DIR}/*.deb
    COMMAND cp ${OUTPUT_FILE} ${REPO_DIR}
    COMMAND apt-ftparchive packages ${REPO_DIR} | gzip -9 > ${REPO_DIR}/Packages.gz
    COMMENT "Memperbarui repository APT di ${REPO_DIR}"
)

# Push ke GitHub (menggunakan branch master, bukan gh-pages)
add_custom_target(update-repo-git
    COMMAND mkdir -p ${REPO_DIR}
    COMMAND touch ${REPO_DIR}/.gitkeep
    COMMAND git add ${REPO_DIR}/*
    COMMAND git commit -m "Update APT repository" || echo "Tidak ada perubahan untuk commit."
    COMMAND git push origin master
    COMMENT "Memperbarui repository APT di GitHub (branch master)"
)


# Upload ke GitHub Releases
add_custom_target(update-release
    COMMAND gh release create v${PKG_VERSION} ${OUTPUT_FILE} --title "Git Helper v${PKG_VERSION}" --notes "Release terbaru Git Helper"
    COMMENT "Mengunggah package ke GitHub Releases"
)

