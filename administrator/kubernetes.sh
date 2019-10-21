KUBERNETES_VERSION=${KUBERNETES_VERSION:-latest}
[ "$KUBERNETES_VERSION" == "latest" ] && KUBERNETES_VERSION=$(curl -s https://api.github.com/repos/kubernetes/kubernetes/releases|grep tag_name| grep -v 'alpha\|beta\|rc' | sort -V | tail -1 | awk -F':' '{print $2}' | sed 's/,//' | xargs | awk -F'-' '{print $1}' | sed 's/v//')
echo net.ipv4.conf.all.forwarding=1 >> /etc/sysctl.conf
echo net.bridge.bridge-nf-call-iptables=1 >> /etc/sysctl.conf
sysctl -p
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=permissive/" /etc/selinux/config
yum install -y wget docker kubelet-$KUBERNETES_VERSION kubectl-$KUBERNETES_VERSION kubeadm-$KUBERNETES_VERSION git lvm2
sed -i "s/--selinux-enabled //" /etc/sysconfig/docker
systemctl enable docker && systemctl start docker
systemctl enable kubelet && systemctl start kubelet
systemctl disable firewalld
systemctl stop firewalld
iptables -F
kubeadm config images pull
kubeadm init --pod-network-cidr=10.244.0.0/16
cp /etc/kubernetes/admin.conf /root/
chown root:root /root/admin.conf
export KUBECONFIG=/root/admin.conf
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config
chown root:root /root/.kube/config
