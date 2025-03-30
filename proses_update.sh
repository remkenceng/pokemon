#!/bin/bash

## BERSIHKAN TAMPILAN
tput reset

proses_membersihkan() {
    rm -rf /usr/local/sbin/*
}
# res1() {
#     cleanup
#     wget https://raw.githubusercontent.com/remkenceng/pokemon/main/menu/menu.zip
#     unzip menu.zip
#     rm -rf menu.zip
#     chmod +x *
#     mv * /usr/local/sbin
# }

proses_unduh() {
    nama_nama_filenya=(
        add-bot-notif addhost addss addssh addtr addvless addws autokill autoreboot
        backup bot bw ceklim cekss cekssh cektr cekvless cekws clearcache clearlog
        del-bot-notif delexp delss delssh deltr delvless delws fixcert hapus-bot
        limit-ip-ssh limitspeed lock m-bot m-noob m-sshws m-ssws m-trial m-trojan
        m-vless m-vmess mbot-backup mbot-panel member member-ws menu menu-backup
        menu-x prot regis renewss renewssh renewtr renewvless renewws reset
        restart restart-bot restore run sd speedtest stop-bot tendang trial trialss
        trialtr trialvless trialws tunnel unlock xp z9dtrial
    )
    for files in "${nama_nama_filenya[@]}"; do
        wget "https://raw.githubusercontent.com/remkenceng/pokemon/main/menu/$files"
    done
}

netfilter-persistent
clear
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat
fun_bar 'res1'
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat
echo -e ""
read -n 1 -s -r -p "Tekan [ Enter ] Untuk Kembali : "
menu