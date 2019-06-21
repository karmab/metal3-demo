export KUBECONFIG=/root/.kube/config
COMPONENT="kubevirt/containerized-data-importer"
{% if cdi_version == 'latest' %}
VERSION=$(curl -s https://api.github.com/repos/$COMPONENT/releases|grep tag_name|sort -V | tail -1 | awk -F':' '{print $2}' | sed 's/,//' | xargs)
{% else %}
VERSION={{ cdi_version }}
{% endif %}

kubectl create -f https://github.com/$COMPONENT/releases/download/$VERSION/cdi-operator.yaml
kubectl create -f https://github.com/$COMPONENT/releases/download/$VERSION/cdi-operator-cr.yaml
