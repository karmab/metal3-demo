CDI_VERSION=${CDI_VERSION:-latest}
[ "$CDI_VERSION" == "latest" ] && CDI_VERSION=$(curl -s https://api.github.com/repos/kubevirt/containerized-data-importer/releases|grep tag_name|sort -V | tail -1 | awk -F':' '{print $2}' | sed 's/,//' | xargs)
kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$CDI_VERSION/cdi-operator.yaml
kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$CDI_VERSION/cdi-operator-cr.yaml
