echo net.ipv4.conf.all.forwarding=1 >> /etc/sysctl.conf
echo net.bridge.bridge-nf-call-iptables=1 >> /etc/sysctl.conf
sysctl -w
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=permissive/" /etc/selinux/config
yum install -y wget docker kubelet-{{ kubernetes_version }} kubectl-{{ kubernetes_version }} kubeadm-{{ kubernetes_version }} git lvm2
sed -i "s/--selinux-enabled //" /etc/sysconfig/docker
systemctl enable docker && systemctl start docker
systemctl enable kubelet && systemctl start kubelet
systemctl disable firewalld
systemctl stop firewalld
iptables -F
