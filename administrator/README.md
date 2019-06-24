
This repository provides instructions on how to deploy an arbitrary number of vms on libvirt with kni ecosystem installed on it

## Requirements

- [*kcli*](https://github.com/karmab/kcli) tool ( configured to point to gcp) with version >= 14.0

### kcli setup

#### Installation 

```
docker pull karmab/kcli
alias kcli="docker run -it --rm --security-opt label=disable -v $HOME/.kcli:/root/.kcli -v /var/lib/libvirt/images:/var/lib/libvirt/images -v /var/run/libvirt:/var/run/libvirt -v $PWD:/workdir karmab/kcli
```

## How to use

```
kcli plan mylab
```

this will create two vms student001,student002,...,student010 and populate them with scripts to deploy the corresponding features

Vms will be accessible using the injected keys and using their fqdn

## Available parameters:

| Parameter         | Default Value            |
|------------------ |--------------------------|
|template           | nested-centos7           | 
|domain             | cnvlab.gce.sysdeseng.com |
|openshift          | true                     |
|disk_size          | 60                       |
|numcpus            | 4                        |
|memory             | 12288                    |
|nodes              | 1                        |
|emulation          | false                    |
|kubernetes_version | latest                   |
|kubevirt_version   | latest                   | 
|cdi_version        | latest                   |

## Clean up

```
kcli plan --yes -d mylab
```
