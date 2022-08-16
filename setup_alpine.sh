#!/bin/sh
mkdir /root/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDiGNsQq6pJuXBAcf7Iq/Fl2zTkSI6SFtuZEGckGQNI6VLi8l5qGuhTlMmDN8XbdkRPHuGHEqWflPV/OpJsU4ioCC4fpxCaPZ40cKLHHZLNtENP8sGHXQhlcZcGQBPGRIyg3llO8NYn/ooVm6fHKKwOtzLzirHKPEptw0LgdJcWb4N2PnYKsygi0IKFdf6jWTww6SW4Zc0iSo2yc8ZAw+Fu6wyWM/rTyeLfjpG8VRzgQ6Mm/sZaI1qzU9ms2wLZsyy4aHPR/kBfNyiCHq9NjgGJEpMwNaYsN08AL5mmjK08blb8OEY4Cl/9Ln/Nw6vr7DdBLFUyJUq6N/o33HEgG7Qr' >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

apk update > /dev/null
apk add openssh > /dev/null
ssh-keygen -A
/usr/sbin/sshd -D &

