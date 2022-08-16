#!/bin/bash
intIP=172.20.20.11

apt-get update > /dev/null
apt-get install -y sshpass wget > /dev/null


wait_ssh() {
    printf "Waiting for ssh: "
    SSH_UP=0
    while [ $SSH_UP -eq 0 ]
    do
        printf "."
        SSH_UP=$(wget --timeout=1 --tries=1 $intIP:22 2>&1 | grep -c connected);
    done
    printf " SSH UP\n"
}


wait_ssh

cat <<'EOF' | sshpass -p admin ssh -tt -o StrictHostKeyChecking=no admin@$intIP
lock database override
set user admin shell /bin/bash
set expert-password-hash $1$Ynf5sP0g$ounsUG9IP.n0OKd/NYoYq/
set interface eth1 ipv4-address 10.2.10.11 mask-length 24
set interface eth1 state on
set interface eth2 ipv4-address 10.2.3.1 mask-length 24
set interface eth2 state on
set static-route 10.2.2.0/24 nexthop gateway address 10.2.10.10 on
save config
exit
EOF

# Now start to EXPERT mode
cat <<'EOF' | sshpass -p admin ssh -tt -o StrictHostKeyChecking=no admin@$intIP
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDiGNsQq6pJuXBAcf7Iq/Fl2zTkSI6SFtuZEGckGQNI6VLi8l5qGuhTlMmDN8XbdkRPHuGHEqWflPV/OpJsU4ioCC4fpxCaPZ40cKLHHZLNtENP8sGHXQhlcZcGQBPGRIyg3llO8NYn/ooVm6fHKKwOtzLzirHKPEptw0LgdJcWb4N2PnYKsygi0IKFdf6jWTww6SW4Zc0iSo2yc8ZAw+Fu6wyWM/rTyeLfjpG8VRzgQ6Mm/sZaI1qzU9ms2wLZsyy4aHPR/kBfNyiCHq9NjgGJEpMwNaYsN08AL5mmjK08blb8OEY4Cl/9Ln/Nw6vr7DdBLFUyJUq6N/o33HEgG7Qr antonr" > /home/admin/.ssh/authorized_keys
chmod 644 /home/admin/.ssh/authorized_keys
config_system -s "hostname=cloudguard_gw1&ftw_sic_key=qwerty&install_security_managment=false&install_security_gw=true&gateway_daip=false&install_ppak=true&gateway_cluster_member=false&domainname=il.cparch.in"
sleep 5
echo Y | reboot
exit
EOF

# sshpass -p admin ssh -tt -o StrictHostKeyChecking=no admin@$intIP "echo Y | reboot"