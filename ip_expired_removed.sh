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
    local expired_ts=$(date -d "$expired_date" +%s 2>/dev/null)
    local today_ts=$(date -d "$today" +%s)
    [ -z "$expired_ts" ] && return 1
    [ "$expired_ts" -lt "$today_ts" ]
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
echo ""
git commit -m "Ip Expired Removed ..... !"
echo ""
git push

echo ""
echo "Penghapusan Ip Expired Selesai ..... !"
echo ""

rm -rf "$TEMP_DIR"
cd .. || exit