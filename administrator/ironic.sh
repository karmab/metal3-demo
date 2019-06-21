WORKING_DIR=${WORKING_DIR:-"/opt/metal3-dev-env"}
NODES_FILE=${NODES_FILE:-"${WORKING_DIR}/ironic_nodes.json"}
NODES_PLATFORM=${NODES_PLATFORM:-"libvirt"}

# Ironic vars
export IRONIC_IMAGE=${IRONIC_IMAGE:-"quay.io/metal3-io/ironic:master"}
export IRONIC_INSPECTOR_IMAGE=${IRONIC_INSPECTOR_IMAGE:-"quay.io/metal3-io/ironic-inspector"}
export IRONIC_DATA_DIR="$WORKING_DIR/ironic"

yum -y install centos-release-openstack-stein.noarch
yum -y install python2-openstackclient python2-ironicclient
mkdir $WORKING_DIR
chown root:root $WORKING_DIR
chmod 755 $WORKING_DIR
mkdir -p "$IRONIC_DATA_DIR/html/images"
pushd "$IRONIC_DATA_DIR/html/images"
[ ! -f ironic-python-agent.initramfs ] || curl --insecure --compressed -L https://images.rdoproject.org/master/rdo_trunk/current-tripleo-rdo/ironic-python-agent.tar | tar -xf -
CENTOS_IMAGE=CentOS-7-x86_64-GenericCloud-1901.qcow2
[ ! -f ${CENTOS_IMAGE} ] || curl --insecure --compressed -O -L http://cloud.centos.org/centos/7/images/${CENTOS_IMAGE}
popd

# set password for mariadb
mariadb_password=$(echo $(date;hostname)|sha256sum |cut -c-20)
# Create pod
#podman pod create -n ironic-pod 
mkdir -p $IRONIC_DATA_DIR
docker run -d --net host --privileged --name httpd -v $IRONIC_DATA_DIR:/shared --entrypoint /bin/runhttpd ${IRONIC_IMAGE}
docker run -d --net host --privileged --name mariadb -v $IRONIC_DATA_DIR:/shared --entrypoint /bin/runmariadb --env MARIADB_PASSWORD=$mariadb_password ${IRONIC_IMAGE}
docker run -d --net host --privileged --name ironic --env MARIADB_PASSWORD=$mariadb_password -v $IRONIC_DATA_DIR:/shared ${IRONIC_IMAGE}
#docker run -d --net host --privileged --name ironic-inspector "${IRONIC_INSPECTOR_IMAGE}"
