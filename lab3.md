## Use KubeVirt to create a legacy VM

### Create a Virtual Machine

Explore The VM Manifest. Note it uses a [container disk](https://kubevirt.io/user-guide/docs/latest/creating-virtual-machines/disks-and-volumes.html#containerdisk) and as such doesn't persist data. Such container disks currently exist for alpine, cirros and fedora.

```
cat ~/vm_containerdisk.yml
```

Launch this vm:

```
kubectl create secret generic tvshows-secret --from-file=userdata=/root/tvshows-user-data -n default
kubectl create -f /root/kubevirt_tvshows.yml -n default
```

Output should be similar to the following

```
  virtualmachine.kubevirt.io "tvshows" created
```

Confirm the vm is ready by checking its underlying pod:

In both commands, the indicated ip can be used to connect to the vm

```
kubectl get pod -o wide
kubectl get vmi
```

Sample output:

```
# kubectl get pod -o wide -n default
NAME                          READY   STATUS    RESTARTS   AGE   IP            NODE                              NOMINATED NODE   READINESS GATES
virt-launcher-tvshows-m87rf   2/2     Running   0          76s   10.244.0.62   metal3-kubernetes.karmalabs.com   <none>           <none>
# kubectl get vmi -n default
NAME      AGE   PHASE     IP            NODENAME
tvshows   98s   Running   10.244.0.62   metal3-kubernetes.karmalabs.com
```

### Connect using service 

We can "expose" any port of the vm so that we can access it from the outside.

Expose the ssh port of your VM:

```
kubectl create -f /root/tvshows_service.yml
```

Access the VM using the exposed port

[Next Lab](lab4.md)\
[Previous Lab](lab2.md)\
[Home](README.md)
