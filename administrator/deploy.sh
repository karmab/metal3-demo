mkdir /root/install
sh /root/kubernetes.sh > /root/install/kubernetes.log 2>&1
{% if bmo -%}
sh /root/baremetal.sh > /root/install/baremetal.log 2>&1
sh /root/ironic.sh  > /root/install/ironic.log 2>&1
{%- endif %}
{% if kubevirt -%}
sh /root/kubevirt.sh  > /root/install/kubevirt.log 2>&1
{%- endif %}
{% if cdi -%}
sh /root/cdi.sh  > /root/install/cdi.log 2>&1
{%- endif %}
{% if rook -%}
sh /root/rook.sh  > /root/install/rook.log 2>&1
{%- endif %}
{% if istio -%}
sh /root/istio.sh  > /root/install/istio.log 2>&1
{% if knative -%}
sh /root/knative.sh  > /root/install/knative.log 2>&1
{%- endif %}
{%- endif %}
{% if kafka -%}
sh /root/kafka.sh  > /root/install/kafka.log 2>&1
{%- endif %}
{% if olm -%}
sh /root/olm.sh  > /root/install/olm.log 2>&1
{%- endif %}
