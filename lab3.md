## Use KubeVirt to create a VM

We are going to create a kubevirt virtualmachine which will run a mysql+flask application based on the code available at https://github.com/karmab/tvshows

### Create a Virtual Machine

First, we provision a disk to use to store the data of our application, which should get bound a few seconds afterwards

```console
[root@metal3-kubernetes ~]# kubectl create -f kubevirt_tvshows_pvc.yml
persistentvolumeclaim/tvshows-disk created
[root@metal3-kubernetes ~]# kubectl get pvc -n default
NAME           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS      AGE
tvshows-disk   Bound    pvc-8cee5c7b-c81c-4f5a-8da1-b6abce1cd4d0   10Gi       RWO            rook-ceph-block   2m50s
```

Then, we deploy our vm along with a secret to store the userdata for our vm ( as it contains a lot of characters, we can't embed it in the kubevirt definition)

Let's substitute TVDB_KEY environment variable in our secret

```console
[root@metal3-kubernetes ~]# sed -i "s/export TVDB_KEY=/export TVDB_KEY=$TVDB_KEY/" /root/tvshows-user-data
```

We then deploy the vm:

```console
[root@metal3-kubernetes ~]# kubectl create secret generic tvshows-secret --from-file=userdata=/root/tvshows-user-data -n default
secret/tvshows-secret created
[root@metal3-kubernetes ~]# kubectl create -f /root/kubevirt_tvshows.yml -n default
virtualmachine.kubevirt.io/tvshows created
```

We can see how our vm is running

```console
[root@metal3-kubernetes ~]# kubectl get vmi -n default
NAME      AGE     PHASE     IP            NODENAME
tvshows   2m56s   Running   10.244.0.28   metal3-kubernetes.karmalabs.com
```

### Connect to our app

We can connect to our app by exposing a service. For this, we leverage metallb.

Alternatively, a NodePort definition can be used

```console
[root@metal3-kubernetes ~]# kubectl create -f tvshows_svc_lb.yml
service/tvshows-web created
```

we can then use the following command to find out which ip metallb assigned to this service

```console
[root@metal3-kubernetes ~]# kubectl get svc -n default tvshows-web
NAME          TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)          AGE
tvshows-web   LoadBalancer   10.110.114.81   192.168.122.245   9000:31580/TCP   54s
```

Browse to the app and play with it at http://192.168.122.245:9000!

[Next Lab](lab4.md)\
[Previous Lab](lab2.md)\
[Home](README.md)
