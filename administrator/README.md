
This repository provides instructions on how to deploy an arbitrary number of vms on libvirt with kni ecosystem installed on it

## Requirements

- [*kcli*](https://github.com/karmab/kcli) tool ( configured to point to gcp) with version >= 14.0

### kcli setup

#### Installation 

```
docker pull karmab/kcli
echo alias kcli=\"docker run -it --rm --security-opt label=disable -v $HOME/.kcli:/root/.kcli -v $HOME/.ssh:/root/.ssh -v $PWD:/workdir karmab/kcli\" >> $HOME.bashrc
```

#### Configuration

- copy your service account json file location to .kcli directory
- create a directory *.kcli* in your home directory and a file *config.yml* with the following content, specifying your serviceaccount json file location

```
default:
 client: cnvlab

cnvlab:
 type: gcp
 credentials: ~/.kcli/myproject.json
 enabled: true
 project: cnvlab-209908
 zone: us-central1-b

```

## How to use

the plan file  *kcli_plan.yml* is the main artifact used to run the deployment.
Run the following command from this same directory

```
kcli plan -P nodes=10 cnvlab
```

this will create 10 vms, named student001,student002,...,student010 and populate them with scripts to deploy the corresponding features
requisites.sh and openshift.sh scripts will also be executed to install docker, pull relevant images, and deploy openshift through `oc cluster up`

To launch the plan for kubernetes instead

```
kcli plan -f kcli_plan_kubernetes.yml -P nodes=10 cnvlab
```

You can relaunch the same command with a different value for nodes so that extra instances get created

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
kcli plan --yes -d cnvlab
```
