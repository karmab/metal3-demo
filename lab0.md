## Overview

### Abstract

Kni is a concept meaning Kubernetes Native Infrastructure. The aim is to provide a common ground for virtualization and storage solution on top of Kubernetes.

This lab tries to demonstrate how the following components can be used together to build complex applications native to Kubernetes.

- kubernetes
- baremetal operator
- kubevirt and cdi
- rook
- istio/knative

This lab doesn't require previous Kni experience.

We will use a dedicated 

### Lab Overview

* Add a worker through the baremetal operator
* Deploy a database virtual machine using Kubevirt
* Deploy a 3tier app using containers, a backend operator and our database VM, along with rook storage
* Launch a batch job on it with serverless

### Requirements

- Libvirt Box
- SSH client

### Relevant Links

- [kubevirt](http://kubevirt.io/)
- [kubevirt user guide](https://kubevirt.io/user-guide/docs/latest/welcome/index.html)
- [kubevirt github repo](https://github.com/kubevirt/kubevirt)
- [openshift](https://docs.okd.io/latest/welcome/index.html)

[Next Lab](lab1.md)\
[Home](README.md)
