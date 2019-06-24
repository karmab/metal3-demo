WORKING_DIR=${WORKING_DIR:-"/opt/metal3-dev-env"}
NODES_FILE=${NODES_FILE:-"${WORKING_DIR}/ironic_nodes.json"}
NODES_PLATFORM=${NODES_PLATFORM:-"libvirt"}
provisioning_interface=eth1

# Ironic vars
export IRONIC_IMAGE=${IRONIC_IMAGE:-"quay.io/metal3-io/ironic:master"}
export IRONIC_INSPECTOR_IMAGE=${IRONIC_INSPECTOR_IMAGE:-"quay.io/metal3-io/ironic-inspector"}
export IRONIC_DATA_DIR="$WORKING_DIR/ironic"

yum -y install centos-release-openstack-stein.noarch
yum -y install python2-openstackclient python2-ironicclient python-virtualbmc ipmitool
systemctl enable --now virtualbmc
ssh-keyscan -H 192.168.122.1 >> ~/.ssh/known_hosts
vbmc add kni-node01 --port 6230 --username admin --password admin --libvirt-uri qemu+ssh://root@192.168.122.1/system
mkdir $WORKING_DIR
chown root:root $WORKING_DIR
chmod 755 $WORKING_DIR
mkdir -p "$IRONIC_DATA_DIR/html/images"
pushd "$IRONIC_DATA_DIR/html/images"
[ ! -f ironic-python-agent.initramfs ] || curl --insecure --compressed -L https://images.rdoproject.org/master/rdo_trunk/current-tripleo-rdo/ironic-python-agent.tar | tar -xf -
CENTOS_IMAGE=CentOS-7-x86_64-GenericCloud-1901.qcow2
curl --insecure --compressed -O -L http://cloud.centos.org/centos/7/images/${CENTOS_IMAGE}
curl --insecure --compressed -O -L http://cloud.centos.org/centos/7/images/${CENTOS_IMAGE}.md5sum
popd

# set password for mariadb
mariadb_password=$(echo $(date;hostname)|sha256sum |cut -c-20)
# Create pod
#podman pod create -n ironic-pod 
mkdir -p $IRONIC_DATA_DIR
docker run -d --net host --privileged --name dnsmasq -v $IRONIC_DATA_DIR:/shared --entrypoint /bin/rundnsmasq --env PROVISIONING_INTERFACE=$provisioning_interface --env DNSMASQ_EXCEPT_INTERFACE=$provisioning_interface ${IRONIC_IMAGE}
docker run -d --net host --privileged --name httpd -v $IRONIC_DATA_DIR:/shared --entrypoint /bin/runhttpd ${IRONIC_IMAGE}
docker run -d --net host --privileged --name mariadb -v $IRONIC_DATA_DIR:/shared --entrypoint /bin/runmariadb --env MARIADB_PASSWORD=$mariadb_password ${IRONIC_IMAGE}
docker run -d --net host --privileged --name ironic --env MARIADB_PASSWORD=$mariadb_password -v $IRONIC_DATA_DIR:/shared -e PROVISIONING_INTERFACE=$provisioning_interface ${IRONIC_IMAGE}
#docker run -d --net host --privileged --name ironic-inspector "${IRONIC_INSPECTOR_IMAGE}"
