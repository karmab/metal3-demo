export KUBECONFIG=/root/.kube/config
COMPONENT="kubevirt/kubevirt"
{% if kubevirt_version == 'latest' %}
VERSION=$(curl -s https://api.github.com/repos/$COMPONENT/releases|grep tag_name|sort -V | tail -1 | awk -F':' '{print $2}' | sed 's/,//' | xargs)
{% else %}
VERSION={{ kubevirt_version }}
{% endif %}

kubectl create -f https://github.com/$COMPONENT/releases/download/$VERSION/kubevirt-operator.yaml
kubectl create -f https://github.com/$COMPONENT/releases/download/$VERSION/kubevirt-cr.yaml
