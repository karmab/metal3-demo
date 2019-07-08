export KUBECONFIG=/root/.kube/config
METALLB_VERSION=${METALLB_VERSION:-latest}
DEFAULT_RANGE="192.168.122.245-192.168.122.250"
METALLB_RANGE=${METALLB_RANGE:-$DEFAULT_RANGE}
[ "$METALLB_VERSION" == "latest" ] && METALLB_VERSION=$(curl -s https://api.github.com/repos/danderson/metallb/releases|grep tag_name|sort -V | tail -1 | awk -F':' '{print $2}' | sed 's/,//' | xargs)
kubectl apply -f https://raw.githubusercontent.com/google/metallb/$METALLB_VERSION/manifests/metallb.yaml
echo """apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: my-ip-space
      protocol: layer2
      addresses:
      - $METALLB_RANGE""" > /tmp/cm_metallb.yml
kubectl create -f /tmp/cm_metallb.yml
