## Overview

### Abstract

Metal3 project aims to easily provision kubernetes on baremetal.

This lab tries to demonstrate how the following components can be used together to build complex applications native to Kubernetes.

- kubernetes
- baremetal operator
- kubevirt and cdi
- rook
- istio/knative

We then showcase how we can use it as a common ground for virtualization and storage solution on top.

This lab doesn't require previous Metal3 experience.

We will use a dedicated 

### Lab Overview

* Review environment
* Add a worker through the baremetal operator
* Deploy a database virtual machine using Kubevirt
* Deploy a 3tier app using containers, a backend operator and our database VM, along with rook storage
* Launch a batch job on it with serverless

### Requirements

- Libvirt Box
- SSH client
- Good mood

### Relevant Links

- [kubevirt](http://kubevirt.io/)
- [kubevirt user guide](https://kubevirt.io/user-guide/docs/latest/welcome/index.html)
- [kubevirt github repo](https://github.com/kubevirt/kubevirt)
- [openshift](https://docs.okd.io/latest/welcome/index.html)

[Next Lab](lab1.md)\
[Home](README.md)
