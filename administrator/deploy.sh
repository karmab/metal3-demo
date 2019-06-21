sh /root/kubernetes.sh
mkdir /root/install_logs
{% if bmo %}
sh /root/baremetal.sh > /root/install_logs/baremetal.log 2>&1
{% endif %}
{% if kubevirt %}
sh /root/kubevirt.sh  > /root/install_logs/kubevirt.log 2>&1
{% endif %}
{% if cdi %}
sh /root/cdi.sh  > /root/install_logs/cdi.log 2>&1
{% endif %}
{% if rook %}
sh /root/rook.sh  > /root/install_logs/rook.log 2>&1
{% endif %}
{% if istio %}
sh /root/istio.sh  > /root/install_logs/istio.log 2>&1
{% if knative %}
sh /root/knative.sh  > /root/install_logs/knative.log 2>&1
{% endif %}
{% endif %}
{% if kafka %}
sh /root/kafka.sh  > /root/install_logs/kafka.log 2>&1
{% endif %}
{% if olm %}
sh /root/olm.sh  > /root/install_logs/olm.log 2>&1
{% endif %}
