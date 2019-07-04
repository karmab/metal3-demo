#!/bin/bash 
IP=`ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`
TOKEN=$(kubeadm token create --ttl 0)
HASH=$(openssl x509 -in /etc/kubernetes/pki/ca.crt -noout -pubkey | openssl rsa -pubin -outform DER 2>/dev/null | sha256sum | cut -d' ' -f1)
sed -i "s/IP/$IP/" /root/metal3-node01-user-data
sed -i "s/TOKEN/$TOKEN/" /root/metal3-node01-user-data
sed -i "s/HASH/$HASH/" /root/metal3-node01-user-data
cp /root/.ssh/authorized_keys /root/.ssh/id_rsa.pub
chmod 600 /root/.ssh/id_rsa.pub
SSHKEY=$(cat /root/.ssh/id_rsa.pub)
sed -i "s%SSHKEY%$SSHKEY%" /root/metal3-node01-user-data
DATA=$(cat /root/metal3-node01-user-data | base64 -w 0)
sed -i "s@DATA@$DATA@" /root/metal3-node01-machine.yml
sed -i "s%SSHKEY%$SSHKEY%" /root/tvshows-user-data
