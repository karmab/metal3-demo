WORKING_DIR=${WORKING_DIR:-"/opt/metal3-dev-env"}
export IRONIC_IMAGE=${IRONIC_IMAGE:-"quay.io/metal3-io/ironic:master"}
export IRONIC_INSPECTOR_IMAGE=${IRONIC_INSPECTOR_IMAGE:-"quay.io/metal3-io/ironic-inspector"}
export IRONIC_DATA_DIR="$WORKING_DIR/ironic"

provisioning_interface=eth1
echo """DEVICE=$provisioning_interface
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=static
IPADDR=172.22.0.1
NETMASK=255.255.255.0""" > /etc/sysconfig/network-scripts/ifcfg-$provisioning_interface
ifup $provisioning_interface

yum -y install centos-release-openstack-stein.noarch
yum -y install python2-openstackclient python2-ironicclient python-virtualbmc ipmitool
systemctl enable --now virtualbmc
ssh-keyscan -H 192.168.122.1 >> ~/.ssh/known_hosts
vbmc add kni-node01 --port 6230 --username admin --password admin --libvirt-uri qemu+ssh://root@192.168.122.1/system
vbmc start kni-node01
mkdir $WORKING_DIR
chown root:root $WORKING_DIR
chmod 755 $WORKING_DIR
mkdir -p "$IRONIC_DATA_DIR/html/images"
pushd "$IRONIC_DATA_DIR/html/images"
curl --insecure --compressed -L https://images.rdoproject.org/master/rdo_trunk/current-tripleo-rdo/ironic-python-agent.tar | tar -xf -
CENTOS_IMAGE=CentOS-7-x86_64-GenericCloud-1901.qcow2
curl --insecure --compressed -O -L http://cloud.centos.org/centos/7/images/${CENTOS_IMAGE}
curl --insecure --compressed -O -L http://cloud.centos.org/centos/7/images/${CENTOS_IMAGE}.md5sum
popd

mariadb_password=$(echo $(date;hostname)|sha256sum |cut -c-20)
#podman pod create -n ironic-pod 
mkdir -p $IRONIC_DATA_DIR
docker run -d --net host --privileged --name dnsmasq -v $IRONIC_DATA_DIR:/shared --entrypoint /bin/rundnsmasq --env PROVISIONING_INTERFACE=$provisioning_interface --env DNSMASQ_EXCEPT_INTERFACE=eth0 ${IRONIC_IMAGE}
docker run -d --net host --privileged --name httpd -v $IRONIC_DATA_DIR:/shared --entrypoint /bin/runhttpd ${IRONIC_IMAGE}
docker run -d --net host --privileged --name mariadb -v $IRONIC_DATA_DIR:/shared --entrypoint /bin/runmariadb -e MARIADB_PASSWORD=$mariadb_password ${IRONIC_IMAGE}
docker run -d --net host --privileged --name ironic -e MARIADB_PASSWORD=$mariadb_password -v $IRONIC_DATA_DIR:/shared -e PROVISIONING_INTERFACE=$provisioning_interface ${IRONIC_IMAGE}
docker run -d --net host --privileged --name ironic-inspector -e PROVISIONING_INTERFACE=$provisioning_interface ${IRONIC_INSPECTOR_IMAGE}
#sed -i s@http://:80@http://172.22.0.1:80@ $WORKING_DIR/ironic/html/inspector.ipxe
