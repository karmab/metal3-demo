ROOK_VERSION=${ROOK_VERSION:-latest}
[ "$ROOK_VERSION" == "latest" ] && ROOK_VERSION=$(curl -s https://api.github.com/repos/rook/rook/releases|grep tag_name|sort -V | tail -1 | awk -F':' '{print $2}' | sed 's/,//' | xargs)
cd /root
git clone https://github.com/rook/rook
cd rook
git checkout $ROOK_VERSION
cd cluster/examples/kubernetes/ceph
kubectl create -f common.yaml
kubectl create -f operator.yaml
sed "s/useAllDevices: false/useAllDevices: true/" cluster-test.yaml > cluster.yaml
kubectl create -f cluster.yaml
kubectl create -f /root/rook.yml
