#!/bin/bash

if ! gh auth status > /dev/null 2>&1; then
    gh auth login
fi

TEMP_DIR=$(mktemp -d -t pokemon-XXXX)
git clone --progress --verbose https://github.com/remkenceng/pokemon.git "$TEMP_DIR" > /dev/null 2>&1
cd "$TEMP_DIR" || exit

is_expired() {
    local expired_date="$1"
    local today=$(date +%Y-%m-%d)
    if [ "$(date -d "$expired_date" +%s 2>/dev/null)" -lt "$(date -d "$today" +%s)" ]; then
        return 0
    else
        return 1
    fi
}

TEMP_FILE=$(mktemp)
while IFS='|' read -r username ip expired; do
    expired=$(echo "$expired" | xargs)
    if is_expired "$expired"; then
        echo "Menghapus: $username | $ip | $expired (EXPIRED)"
    else
        echo "$username | $ip | $expired" >> "$TEMP_FILE"
    fi
done < izin/ip

mv "$TEMP_FILE" izin/ip

git add izin/ip
git commit -m "Ip Expired Removed ..... !"
echo ""
git push

echo ""
echo "Penghapusan Ip Expired Selesai ..... !"
echo ""

rm -rf "$TEMP_DIR"
cd .. || exit
