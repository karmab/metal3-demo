OLM_VERSION=${OLM_VERSION:-latest}
[ "$OLM_VERSION" == "latest" ] && OLM_VERSION=$(curl -s https://api.github.com/repos/operator-framework/operator-lifecycle-manager/releases|grep tag_name|sort -V | tail -1 | awk -F':' '{print $2}' | sed 's/,//' | xargs)
kubectl apply -f https://github.com/operator-framework/operator-lifecycle-manager/releases/download/$OLM_VERSION/crds.yaml
kubectl apply -f https://github.com/operator-framework/operator-lifecycle-manager/releases/download/$OLM_VERSION/olm.yaml
