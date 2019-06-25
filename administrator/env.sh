export KUBECONFIG=/root/.kube/config
export KUBERNETES_REPO="kubernetes/kubernetes"
export KUBEVIRT_REPO="kubevirt/kubevirt"
export CDI_REPO="kubevirt/containerized-data-importer"
export OLM_REPO="operator-framework/operator-lifecycle-manager"
export ROOK_REPO="rook/rook"
{% if kubernetes_version == 'latest' -%}
export KUBERNETES_VERSION=$(curl -s https://api.github.com/repos/$KUBERNETES_REPO/releases|grep tag_name|sort -V | tail -1 | awk -F':' '{print $2}' | sed 's/,//' | xargs)
{%- else -%}
export KUBERNETES_VERSION={{ kubernetes_version }}
{%- endif %}
{% if kubevirt_version == 'latest' -%}
export KUBEVIRT_VERSION=$(curl -s https://api.github.com/repos/$KUBEVIRT_REPO/releases|grep tag_name|sort -V | tail -1 | awk -F':' '{print $2}' | sed 's/,//' | xargs)
{%- else -%}
export KUBEVIRT_VERSION={{ kubevirt_version }}
{%- endif %}
{% if cdi_version == 'latest' -%}
export CDI_VERSION=$(curl -s https://api.github.com/repos/$CDI_REPO/releases|grep tag_name|sort -V | tail -1 | awk -F':' '{print $2}' | sed 's/,//' | xargs)
{%- else -%}
export CDI_VERSION={{ cdi_version }}
{%- endif %}
{% if olm_version == 'latest' -%}
OLM_VERSION=$(curl -s https://api.github.com/repos/$OLM_REPO/releases|grep tag_name|sort -V | tail -1 | awk -F':' '{print $2}' | sed 's/,//' | xargs)
{%- else -%}
OLM_VERSION={{ olm_version }}
{%- endif %}
{% if rook_version == 'latest' -%}
ROOK_VERSION=$(curl -s https://api.github.com/repos/$ROOK_REPO/releases|grep tag_name|sort -V | tail -1 | awk -F':' '{print $2}' | sed 's/,//' | xargs)
{%- else -%}
ROOK_VERSION={{ rook_version }}
{%- endif %}
export ISTIO_VERSION="1.1.3"
export HELM_VERSION="v2.14.1"
export KNATIVE_VERSION="v0.6.0"
export KAFKA_VERSION="0.12.0"
