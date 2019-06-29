## Use Baremetal Operator to add a worker

BMO is already deployed

```
kubectl create -f metal3-node01-machine.yml 
```

check baremetal hosts

```
kubectl get baremetalhost -n metal3
```

check machines

```
kubectl get machine -n metal3 metal3-node01
```

```
openstack baremetal node list
```

Once the node is provisioned

```
kubectl get node
```

We have a new worker at our disposal! and it even added as an new node that kubevirt can use ( check the new virt launcher pod)

```
kubectl get pod -n kubevirt -o wide
```

This concludes this section of the lab.

[Next Lab](lab3.md)\
[Previous Lab](lab1.md)\
[Home](README.md)
