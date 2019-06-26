echo """DEVICE=eth1
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=static
IPADDR=172.22.0.1
NETMASK=255.255.255.0""" > /etc/sysconfig/network-scripts/ifcfg-eth1
ifup eth1

yum -y install centos-release-openstack-stein.noarch
yum -y install python2-openstackclient python2-ironicclient python-virtualbmc ipmitool
systemctl enable --now virtualbmc
ssh-keyscan -H 192.168.122.1 >> ~/.ssh/known_hosts
vbmc add kni-node01 --port 6230 --username admin --password admin --libvirt-uri qemu+ssh://root@192.168.122.1/system
vbmc start kni-node01
mkdir /opt/metal3-dev-env
chown root:root /opt/metal3-dev-env
chmod 755 /opt/metal3-dev-env
mkdir -p "/opt/metal3-dev-env/html/images"
pushd "/opt/metal3-dev-env/html/images"
curl --insecure --compressed -L https://images.rdoproject.org/master/rdo_trunk/current-tripleo-rdo/ironic-python-agent.tar | tar -xf -
curl --insecure --compressed -O -L http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1901.qcow2
curl --insecure --compressed -O -L http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1901.qcow2.md5sum
chmod 777 /opt/metal3-dev-env/html/images/*
popd

mariadb_password=$(echo $(date;hostname)|sha256sum |cut -c-20)
mkdir -p /opt/metal3-dev-env
docker run -d --net host --privileged --name dnsmasq -v /opt/metal3-dev-env:/shared --entrypoint /bin/rundnsmasq -e PROVISIONING_INTERFACE=eth1 -e DNSMASQ_EXCEPT_INTERFACE=eth0 quay.io/metal3-io/ironic:master
docker run -d --net host --privileged --name httpd -v /opt/metal3-dev-env:/shared --entrypoint /bin/runhttpd quay.io/metal3-io/ironic:master
docker run -d --net host --privileged --name mariadb -v /opt/metal3-dev-env:/shared --entrypoint /bin/runmariadb -e MARIADB_PASSWORD=$mariadb_password quay.io/metal3-io/ironic:master
docker run -d --net host --privileged --name ironic -e MARIADB_PASSWORD=$mariadb_password -v /opt/metal3-dev-env:/shared -e PROVISIONING_INTERFACE=eth1 quay.io/metal3-io/ironic:master
docker run -d --net host --privileged --name ironic-inspector -e PROVISIONING_INTERFACE=eth1 quay.io/metal3-io/ironic-inspector
sed -i s@http://:80@http://172.22.0.1:80@ /opt/metal3-dev-env/html/inspector.ipxe
