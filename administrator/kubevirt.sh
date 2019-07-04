export KUBECONFIG=/root/.kube/config
KUBEVIRT_VERSION=${KUBEVIRT_VERSION:-latest}
[ "$KUBEVIRT_VERSION" == "latest" ] && KUBEVIRT_VERSION=$(curl -s https://api.github.com/repos/kubevirt/kubevirt/releases|grep tag_name|sort -V | tail -1 | awk -F':' '{print $2}' | sed 's/,//' | xargs)
export KUBECONFIG=/root/.kube/config
kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/$KUBEVIRT_VERSION/kubevirt-operator.yaml
kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/$KUBEVIRT_VERSION/kubevirt-cr.yaml
curl -L https://github.com/kubevirt/kubevirt/releases/download/$KUBEVIRT_VERSION/virtctl-$KUBEVIRT_VERSION-linux-amd64 > /usr/bin/virtctl
chmod u+x /usr/bin/virtctl
