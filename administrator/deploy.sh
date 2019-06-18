sh /root/kubernetes.sh
{% if baremetal %}
sh /root/baremetal.sh
{% endif %}
{% if kubevirt %}
sh /root/kubevirt.sh
{% endif %}
{% if cdi %}
sh /root/cdi.sh
{% endif %}
{% if rook %}
sh /root/rook.sh
{% endif %}
{% if istio %}
sh /root/istio.sh
{% if knative %}
sh /root/knative.sh
{% endif %}
{% endif %}
{% if kafka %}
sh /root/kafka.sh
{% endif %}
