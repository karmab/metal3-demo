yum -y install centos-release-openstack-stein.noarch bridge-utils
yum -y install python2-virtualbmc ipmitool
echo -e "DEVICE=provisioning\nTYPE=Bridge\nONBOOT=yes\nNM_CONTROLLED=no\nBOOTPROTO=static\nIPADDR=172.22.0.1\nNETMASK=255.255.255.0" > /etc/sysconfig/network-scripts/ifcfg-provisioning
echo -e "DEVICE=eth1\nTYPE=Ethernet\nONBOOT=yes\nNM_CONTROLLED=no\nBRIDGE=provisioning" > /etc/sysconfig/network-scripts/ifcfg-eth1
ifup eth1
ifup provisioning

systemctl enable --now virtualbmc
ssh-keyscan -H 192.168.122.1 >> ~/.ssh/known_hosts
vbmc add metal3-node01 --port 6230 --username admin --password admin --libvirt-uri qemu+ssh://root@192.168.122.1/system
vbmc start metal3-node01
mkdir /opt/metal3-dev-env
chown root:root /opt/metal3-dev-env
chmod 755 /opt/metal3-dev-env
mkdir -p "/opt/metal3-dev-env/html/images"
pushd "/opt/metal3-dev-env/html/images"
curl --insecure --compressed -L https://images.rdoproject.org/master/rdo_trunk/current-tripleo-rdo/ironic-python-agent.tar | tar -xf -
curl --insecure --compressed -O -L http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1901.qcow2
md5sum CentOS-7-x86_64-GenericCloud-1901.qcow2 | awk '{print $1}' > CentOS-7-x86_64-GenericCloud-1901.qcow2.md5sum
#wget -O rhcos.qcow2.gz https://releases-rhcos.svc.ci.openshift.org/storage/releases/ootpa/410.8.20190520.1/rhcos-410.8.20190520.1-openstack.qcow2
#gunzip rhcos.qcow2.gz
#md5sum rhcos.qcow2 | awk '{print $1}' > rhcos.qcow2.md5sum
chmod 777 /opt/metal3-dev-env/html/images/*
popd

mariadb_password=$(echo $(date;hostname)|sha256sum |cut -c-20)
mkdir -p /opt/metal3-dev-env
docker run -d --net host --privileged --name dnsmasq -v /opt/metal3-dev-env:/shared --entrypoint /bin/rundnsmasq -e PROVISIONING_INTERFACE=provisioning -e DNSMASQ_EXCEPT_INTERFACE=eth0 quay.io/metal3-io/ironic:master
docker run -d --net host --privileged --name httpd -v /opt/metal3-dev-env:/shared --entrypoint /bin/runhttpd quay.io/metal3-io/ironic:master
docker run -d --net host --privileged --name mariadb -v /opt/metal3-dev-env:/shared --entrypoint /bin/runmariadb -e MARIADB_PASSWORD=$mariadb_password quay.io/metal3-io/ironic:master
docker run -d --net host --privileged --name ironic -e MARIADB_PASSWORD=$mariadb_password -v /opt/metal3-dev-env:/shared -e PROVISIONING_INTERFACE=provisioning quay.io/metal3-io/ironic:master
docker run -d --net host --privileged --name ironic-inspector -e PROVISIONING_INTERFACE=provisioning quay.io/metal3-io/ironic-inspector
sed -i s@http://:80@http://172.22.0.1:80@ /opt/metal3-dev-env/html/inspector.ipxe
echo export OS_TOKEN=fake-token > /etc/profile.d/ironic.sh
echo export OS_URL=http://localhost:6385 >> /etc/profile.d/ironic.sh
