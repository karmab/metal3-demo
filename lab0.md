## Overview

### Abstract

Kni is a concept meaning Kubernetes Native Infrastructure. The aim is to provide a common ground for virtualization and storage solution on top of Kubernetes.

This lab tries to demonstrate how the following components can be used together to build complex applications native to Kubernetes.

- kubernetes
- kubevirt and cdi
- rook

This lab doesn't require previous Kni experience.

We will use a dedicated public VM per student where components are already installed.

### Lab Overview

* Import data with cdi into rook
* Deploy a virtual machine using Kubevirt.
* Handle connectivity with Multus.

### Requirements

- Laptop with a modern browser for OCP console
- SSH client

### Relevant Links

- [kubevirt](http://kubevirt.io/)
- [kubevirt user guide](https://kubevirt.io/user-guide/docs/latest/welcome/index.html)
- [kubevirt github repo](https://github.com/kubevirt/kubevirt)
- [openshift](https://docs.okd.io/latest/welcome/index.html)

[Next Lab](lab1.md)\
[Home](README.md)
