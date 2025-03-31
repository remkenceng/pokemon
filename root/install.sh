wget -q -O /etc/ssh/sshd_config https://raw.githubusercontent.com/remkenceng/pokemon/main/root/sshd_config
systemctl restart sshd

clear
read -sp "Input New Password : " pwe
echo

usermod -p "$(perl -e "print crypt('$pwe', 'Q4')")" root

clear
printf " Mohon Simpan Informasi Ini\n"
printf "============================================\n"
printf " Ip         = $(curl -Ls http://ipinfo.io/ip)\n"
printf " Username   = root\n"
printf " Password   = $pwe\n"
printf "============================================\n"
echo ""

rm -rf *
exit