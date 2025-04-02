#!/bin/bash

if ! command -v gh &> /dev/null; then
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

is_date_older() {
    local date1=$1
    local date2=$2
    
    local ts1=$(date -d "$(echo $date1 | awk -F'-' '{print $3"-"$2"-"$1}')" +%s)
    local ts2=$(date -d "$(echo $date2 | awk -F'-' '{print $3"-"$2"-"$1}')" +%s)
    
    [ "$ts1" -lt "$ts2" ]
}

today=$(date +"%d-%m-%Y")

temp_file=$(mktemp)

changed=false

while IFS= read -r line; do
    expired_date=$(echo "$line" | awk -F'|' '{print $3}' | xargs)
    
    if [[ $(echo "$line" | tr '|' '\n' | wc -l) -eq 3 ]]; then
        if is_date_older "$expired_date" "$today"; then
            echo "Menghapus Ip Expired : $line"
            changed=true
            continue
        fi
    fi
    echo "$line" >> "$temp_file"
done < "izin/ip"

if [ "$changed" = true ]; then
    mv "$temp_file" "izin/ip"
    git add izin/ip
    git commit -m "Menghapus Ip Expired di Tanggal : $today"
    git push
    echo ""
    echo "Ip Berhasil Dihapus Dari Database !"
else
    rm "$temp_file"
    echo ""
    echo "Ip Tidak Ada Yang Expired !"
fi

rm -rf "$TEMP_DIR"
