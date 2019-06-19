sh /root/kubernetes.sh
{% if bmo %}
sh /root/baremetal.sh > /root/baremetal.log 2>&1
{% endif %}
{% if kubevirt %}
sh /root/kubevirt.sh  > /root/kubevirt.log 2>&1
{% endif %}
{% if cdi %}
sh /root/cdi.sh  > /root/cdi.log 2>&1
{% endif %}
{% if rook %}
sh /root/rook.sh  > /root/rook.log 2>&1
{% endif %}
{% if istio %}
sh /root/istio.sh  > /root/istio.log 2>&1
{% if knative %}
sh /root/knative.sh  > /root/knative.log 2>&1
{% endif %}
{% endif %}
{% if kafka %}
sh /root/kafka.sh  > /root/kafka.log 2>&1
{% endif %}
{% if olm %}
sh /root/olm.sh  > /root/olm.log 2>&1
{% endif %}
