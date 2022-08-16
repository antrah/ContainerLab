#!/bin/bash
# DNS, subnet (3 octets) for eth2, eth3
# /tmp/setup.sh 192.168.122.1 10.2.2 10.2.3

intIP=172.31.255.30

wait_ssh() {
    printf "Waiting for ssh: "
    SSH_UP=0
    while [ $SSH_UP -eq 0 ]
    do
        printf "."
        SSH_UP=$(wget --timeout=1 --tries=1 $intIP:22 2>&1 | grep -c Read);
    done
    printf " SSH UP"
}

apt-get update > /dev/null
apt-get install -y sshpass > /dev/null

wait_ssh

cat <<EOF | sshpass -p admin ssh -tt -o StrictHostKeyChecking=no admin@$intIP
/ip dns set servers=$1;
/ip address add address=$2.1/24 interface=ether2 network=$2.0;
/ip address add address=$3.1/24 interface=ether3 network=$3.0;
/ip route add distance=1 gateway=172.31.255.29;
EOF

# for key ssh auth  (not tested)
# /file print file=mykey;
# /file set mykey contents="copy and paste contents of ~/.ssh/id_rsa.pub here";
# /user ssh-keys import public-key-file=mykey.txt
# /ip ssh set always-allow-password-login=yes
