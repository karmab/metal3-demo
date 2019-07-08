## Introduction / Connectivity

In this section, we review the environment and what s installed

### Deployment

we use [kcli](https://kcli.readthedocs.io) to do the initial deployment, with the following alias

```
podman pull karmab/kcli
alias kcli="podman run -it --rm --security-opt label=disable -v $HOME/.kcli:/root/.kcli -v /var/lib/libvirt/images:/var/lib/libvirt/images -v /var/run/libvirt:/var/run/libvirt -v $PWD:/workdir karmab/kcli"
```

Once installed, we deploy the kcli plan in the administrator directory with the following command:

```console
jhendrix@vegeta ~ $ kcli plan metal3
using default input file kcli_plan.yml
Deploying Networks...
Network provisioning deployed
Deploying Vms...
Waiting 5 seconds to grab ip and create DNS record...
Waiting 5 seconds to grab ip and create DNS record...
Waiting 5 seconds to grab ip and create DNS record...
metal3-kubernetes deployed on local
metal3-node01 deployed on local
```

By default, the plan will create

- two vms, named metal3-kubernetes and metal3-node01
- install kubernetes, baremetal operator, ironic, kubevirt and metallb on the metal3-kubernetes
- not provision metal3-node01 and let it ready to be deployed
- registers with vbmc the node metal3-node01
- prepares some cloudinit data to later be injected to the metal3-node01

The plan can optionally deploys the following extra components:
- istio/knative
- cdi
- kafka
- olm

This concludes this section of the lab.

[Next Lab](lab2.md)\
[Previous Lab](lab0.md)\
[Home](README.md)
