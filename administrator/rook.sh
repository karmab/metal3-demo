cd rook/cluster/examples/kubernetes/ceph
COMPONENT="rook/rook"
{% if rook_version == 'latest' %}
VERSION=$(curl -s https://api.github.com/repos/$COMPONENT/releases|grep tag_name|sort -V | tail -1 | awk -F':' '{print $2}' | sed 's/,//' | xargs)
{% else %}
VERSION={{ rook_version }}
{% endif %}

yum -y install lvm2
cd /root
git clone https://github.com/rook/rook
git checkout $VERSION
cd cluster/examples/kubernetes/ceph
kubectl create -f common.yaml
kubectl create -f operator.yaml
sed "s/useAllDevices: false/useAllDevices: true/" cluster-test.yaml > cluster.yaml
kubectl create -f cluster.yaml
kubectl create -f /root/rook.yml
