source /root/env.sh
cd /root
git clone https://github.com/$ROOK_REPO
cd rook
git checkout $ROOK_VERSION
cd cluster/examples/kubernetes/ceph
kubectl create -f common.yaml
kubectl create -f operator.yaml
sed "s/useAllDevices: false/useAllDevices: true/" cluster-test.yaml > cluster.yaml
kubectl create -f cluster.yaml
kubectl create -f /root/rook.yml
