# Redeploy the app as a container workload

In this section, we migrate our kubevirt vm based app to a container workload.

```console
[root@metal3-kubernetes ~]# kubectl create -f https://raw.githubusercontent.com/karmab/tvshows/master/crd.yml
customresourcedefinition.apiextensions.k8s.io/tvshows.kool.karmalabs.com created
[root@metal3-kubernetes ~]# wget https://raw.githubusercontent.com/karmab/tvshows/deployment.yml
--2019-07-08 18:47:46--  https://raw.githubusercontent.com/karmab/tvshows/master/deployment.yml
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 151.101.0.133, 151.101.64.133, 151.101.128.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|151.101.0.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 399 [text/plain]
Saving to: ‘deployment.yml’

100%[=====================================================================================================================================================>] 399         --.-K/s   in 0s

2019-07-08 18:47:46 (59.5 MB/s) - ‘deployment.yml’ saved [399/399]
[root@metal3-kubernetes ~]# sed "s/value: /value: \"$TVDB_KEY\"/" deployment.yml | kubectl create -f -
deployment.apps/tvshows created
[root@metal3-kubernetes ~]# kubectl create -f tvshows_svc_lb_v2.yml
service/tvshows-web-v2 created
```

This new version of the app runs as a container and use custom resource definitions

We can create sample tvshows using kubectl:

```console
[root@metal3-kubernetes ~]# kubectl apply -n default -f https://raw.githubusercontent.com/karmab/tvshows/master/crds/breakingbad.yml -f https://raw.githubusercontent.com/karmab/tvshows/master/crds/friends.yml
tvshow.kool.karmalabs.com/breaking-bad created
tvshow.kool.karmalabs.com/friends created
```

Those objects are stored as custom resource definitions within kubernetes:

```console
[root@metal3-kubernetes ~]# kubectl get tvshows -n default
NAME           AGE
breaking-bad   16s
friends        16s
```

As in the previous section, gather the load balancer ip and connect to this app, this time using custom resource definitions

```console
[root@metal3-kubernetes ~]# kubectl get svc -n default tvshows-web-v2
NAME             TYPE           CLUSTER-IP      EXTERNAL-IP       PORT(S)          AGE
tvshows-web-v2   LoadBalancer   10.110.114.81   192.168.122.246   9000:32580/TCP   54s
```

[Next Lab](lab5.md)\
[Previous Lab](lab3.md)\
[Home](README.md)
