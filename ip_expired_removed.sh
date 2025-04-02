#!/bin/bash

# Script untuk menghapus IP yang sudah expired berdasarkan tanggal (format DD-MM-YYYY)

if ! command -v gh &> /dev/null; then
    echo "gh tidak terinstall, menginstall..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
      && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
      && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
      && sudo apt update \
      && sudo apt install gh -y
fi

if ! gh auth status > /dev/null 2>&1; then
    gh auth login
fi

TEMP_DIR=$(mktemp -d -t pokemon-XXXX)
git clone --progress --verbose https://github.com/remkenceng/pokemon.git "$TEMP_DIR" > /dev/null 2>&1
cd "$TEMP_DIR" || exit

# Fungsi untuk membandingkan tanggal
is_date_older() {
    local date1=$1  # Format DD-MM-YYYY
    local date2=$2  # Format DD-MM-YYYY
    
    # Konversi ke timestamp
    local ts1=$(date -d "$(echo $date1 | awk -F'-' '{print $3"-"$2"-"$1}')" +%s)
    local ts2=$(date -d "$(echo $date2 | awk -F'-' '{print $3"-"$2"-"$1}')" +%s)
    
    [ "$ts1" -lt "$ts2" ]
}

# Dapatkan tanggal hari ini dalam format DD-MM-YYYY
today=$(date +"%d-%m-%Y")

# File sementara untuk menyimpan data yang belum expired
temp_file=$(mktemp)

# Flag untuk menandai jika ada perubahan
changed=false

# Proses setiap baris di file izin/ip
while IFS= read -r line; do
    # Ekstrak tanggal expired (kolom ketiga setelah split dengan |)
    expired_date=$(echo "$line" | awk -F'|' '{print $3}' | xargs)
    
    # Cek jika line mengandung format yang benar (ada 3 bagian dipisahkan |)
    if [[ $(echo "$line" | tr '|' '\n' | wc -l) -eq 3 ]]; then
        # Bandingkan tanggal
        if is_date_older "$expired_date" "$today"; then
            echo "Menghapus IP yang expired: $line"
            changed=true
            continue
        fi
    fi
    echo "$line" >> "$temp_file"
done < "izin/ip"

# Jika ada perubahan, update file dan push ke GitHub
if [ "$changed" = true ]; then
    mv "$temp_file" "izin/ip"
    git add izin/ip
    git commit -m "Menghapus IP yang sudah expired per $today"
    git push
    echo ""
    echo "IP yang sudah expired berhasil dihapus."
else
    rm "$temp_file"
    echo ""
    echo "Tidak ada IP yang sudah expired."
fi

# Bersihkan
rm -rf "$TEMP_DIR"