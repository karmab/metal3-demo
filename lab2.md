## Use Baremetal Operator to add a worker

In this section, we use the baremetal operator to deploy an extra worker node.

We will use the libvirt virtualmachine metal3-node01 to emulate baremetal. As such, this virtual machine is powered off, empty but can be controlled though IPMI by means of [vbmc](https://docs.openstack.org/virtualbmc/latest/user/)

```console
[root@metal3-kubernetes ~]# vbmc list
+---------------+---------+---------+------+
| Domain name   | Status  | Address | Port |
+---------------+---------+---------+------+
| metal3-node01 | running | ::      | 6230 |
+---------------+---------+---------+------+
```

The virtual machine can indeed be controlled through ipmi:

```console
[root@metal3-kubernetes ~]# ipmitool -I lanplus -U admin -P admin -H 127.0.0.1 -p 6230 power status
Chassis Power is off
```

Let's define a baremetal host for it.

```console
[root@metal3-kubernetes ~]# kubectl create -f metal3-node01-baremetal.yml
secret/metal3-node01-credentials created
baremetalhost.metal3.io/metal3-node01 created
```

Note that we put it in an offline state so that it doesn't get provisioned directly

```console
[root@metal3-kubernetes ~]# kubectl get baremetalhost -n metal3
NAME            STATUS   PROVISIONING STATUS   CONSUMER   BMC                      HARDWARE PROFILE   ONLINE   ERROR
metal3-node01   OK       inspecting                       ipmi://172.22.0.1:6230                      false
```

This node gets inspected and once finished will move to the *ready* status for provisioning

Now, let's create a new machine

```console
[root@metal3-kubernetes ~]# kubectl create -f metal3-node01-machine.yml
secret/metal3-node01-user-data created
machine.cluster.k8s.io/metal3-node01 created
```

We can see there's a new machine which needs provisioning, an with an annotation metal3.io/BareMetalHost pointing to the baremetalhost that was assigned for provisioning

```console
[root@metal3-kubernetes ~]# kubectl get machine -n metal3 metal3-node01 -o yaml
apiVersion: cluster.k8s.io/v1alpha1
kind: Machine
metadata:
  annotations:
    metal3.io/BareMetalHost: metal3/metal3-node01
  creationTimestamp: "2019-07-08T15:30:44Z"
  finalizers:
  - machine.cluster.k8s.io
  generateName: baremetal-machine-
  generation: 2
  name: metal3-node01
  namespace: metal3
  resourceVersion: "6222"
  selfLink: /apis/cluster.k8s.io/v1alpha1/namespaces/metal3/machines/metal3-node01
  uid: 1bfd384a-5467-43b7-98aa-e80e1ace5ce7
spec:
  metadata:
    creationTimestamp: null
  providerSpec:
    value:
      apiVersion: baremetal.cluster.k8s.io/v1alpha1
      image:
        checksum: http://172.22.0.1/images/CentOS-7-x86_64-GenericCloud-1901.qcow2.md5sum
        url: http://172.22.0.1/images/CentOS-7-x86_64-GenericCloud-1901.qcow2
      kind: BareMetalMachineProviderSpec
      userData:
        name: metal3-node01-user-data
        namespace: metal3
  versions:
    kubelet: ""
status:
  addresses:
  - address: 192.168.122.79
    type: InternalIP
  - address: 172.22.0.39
    type: InternalIP
  - address: localhost.localdomain
    type: Hostname
  lastUpdated: "2019-07-08T15:30:44Z"
```

Now, if we check baremetal hosts, we can see how it's getting provisioned

```console
[root@metal3-kubernetes ~]# kubectl get baremetalhost -n metal3
NAME            STATUS   PROVISIONING STATUS   CONSUMER   BMC                      HARDWARE PROFILE   ONLINE   ERROR
metal3-node01   OK       provisioned                       ipmi://172.22.0.1:6230                     true
```

It's also visible on the ironic side

```console
[root@metal3-kubernetes ~]# export OS_TOKEN=fake-token ; export OS_URL=http://localhost:6385 ; openstack baremetal node list
+--------------------------------------+---------------+--------------------------------------+-------------+--------------------+-------------+
| UUID                                 | Name          | Instance UUID                        | Power State | Provisioning State | Maintenance |
+--------------------------------------+---------------+--------------------------------------+-------------+--------------------+-------------+
| 7551cfb4-d758-4ad8-9188-859ee53cf298 | metal3-node01 | 7551cfb4-d758-4ad8-9188-859ee53cf298 | power on    | active             | False       |
+--------------------------------------+---------------+--------------------------------------+-------------+--------------------+-------------+
```

Once the machine/baremetal host is provisioned, we can see we have an extra kubernetes node

```console
[root@metal3-kubernetes ~]# kubectl get node
```

We have a new worker at our disposal! and it even added as an new node that kubevirt can use ( check the new virt handler pod)

```console
[root@metal3-kubernetes ~]# kubectl get pod -n kubevirt -o wide
NAME                               READY   STATUS    RESTARTS   AGE   IP            NODE                              NOMINATED NODE   READINESS GATES
virt-api-79ccd476f-9zl9t           1/1     Running   0          36m   10.244.0.10   metal3-kubernetes.karmalabs.com   <none>           <none>
virt-api-79ccd476f-rvlv9           1/1     Running   0          36m   10.244.0.11   metal3-kubernetes.karmalabs.com   <none>           <none>
virt-controller-6b8b4d55c9-hmmr7   1/1     Running   0          36m   10.244.0.14   metal3-kubernetes.karmalabs.com   <none>           <none>
virt-controller-6b8b4d55c9-wtdvb   1/1     Running   1          36m   10.244.0.12   metal3-kubernetes.karmalabs.com   <none>           <none>
virt-handler-z8pdx                 1/1     Running   0          36m   10.244.0.13   metal3-kubernetes.karmalabs.com   <none>           <none>
virt-handler-z8pdx                 1/1     Running   0          36m   10.244.0.15   metal3-node01.karmalabs.com   <none>           <none>
virt-operator-76d85fb55b-nkjgx     1/1     Running   0          36m   10.244.0.8    metal3-kubernetes.karmalabs.com   <none>           <none>
virt-operator-76d85fb55b-tgx82     1/1     Running   1          36m   10.244.0.7    metal3-kubernetes.karmalabs.com   <none>           <none>
```

This concludes this section of the lab.

[Next Lab](lab3.md)\
[Previous Lab](lab1.md)\
[Home](README.md)
