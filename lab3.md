## Use KubeVirt to create a legacy VM

### Create a Virtual Machine

Explore The VM Manifest. Note it uses a [container disk](https://kubevirt.io/user-guide/docs/latest/creating-virtual-machines/disks-and-volumes.html#containerdisk) and as such doesn't persist data. Such container disks currently exist for alpine, cirros and fedora.

```
cat ~/vm_containerdisk.yml
```

Launch this vm:

```
kubectl project myproject
kubectl create -f ~/vm_containerdisk.yml
```

Output should be similar to the following

```
  virtualmachine.kubevirt.io "vm1" created
```

Confirm the vm is ready by checking its underlying pod:

In both commands, the indicated ip can be used to connect to the vm

```
kubectl get pod -o wide
kubectl get vmi
```

Sample output:

```
# kubectl get pod -o wide
NAME                      READY     STATUS      RESTARTS   AGE       IP            NODE         NOMINATED NODE
ara-1-build               0/1       Completed   0          16m       10.124.0.27   student001   <none>
ara-1-xpxf2               1/1       Running     0          14m       10.124.0.29   student001   <none>
virt-launcher-vm1-2b2v7   2/2       Running     0          2m        10.124.0.35   student001   <none>
# kubectl get vmi
NAME      AGE       PHASE     IP            NODENAME
vm1       2m        Running   10.124.0.35   student003

```

### Connect using service 

We can "expose" any port of the vm so that we can access it from the outside.

Expose the ssh port of your VM:

```
kubectl create -f ~/vm1_svc.yml
```

Access the VM using the exposed port:

```
ssh -p 30000 fedora@student<number>.cnvlab.gce.sysdeseng.com
```

[Next Lab](lab4.md)\
[Previous Lab](lab2.md)\
[Home](README.md)
