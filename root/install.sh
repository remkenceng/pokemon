wget -q -O /etc/ssh/sshd_config https://raw.githubusercontent.com/remkenceng/pokemon/main/root/sshd_config
systemctl restart sshd

clear
echo -n "Input New Password : "
read -s pwe
echo

usermod -p "$(perl -e "print crypt('$pwe', 'Q4')")" root

clear
printf "============================================\n"
printf " Ip         = $(curl -Ls http://ipinfo.io/ip)\n"
printf " Username   = root\n"
printf " Password   = $pwe\n"
printf "============================================\n"
echo ""

read -n 1 -s -r -p "Press [Enter] : "
rm -rf install.sh
bash pokemon.sh
exit