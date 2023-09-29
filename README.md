# K8S (aka: Kubernetes)

<p align="center">
  <a href="https://example.com/">
    <img src="https://via.placeholder.com/72" alt="Logo" width=72 height=72>
  </a>

  <h3 align="center">Logo</h3>

  <p align="center">
    <h2> My notes for setup Kubernetes Cluster </h2>
    <br>
  </p>
</p>


## Table of contents

- [Pre-Requirements](#Pre-requirements)
- [Ecosystem](#Ecosystem)
- [What's included](#whats-included)
- [Bugs and feature requests](#bugs-and-feature-requests)
- [Contributing](#contributing)
- [Creators](#creators)
- [Thanks](#thanks)
- [Copyright and license](#copyright-and-license)


## Pre-Requirements:
We assumed you've already got your servers setup for K8S. This included:

- Ubuntu Servers in odd number (minimum 3 nodes). Our setup on 22.04 LTS but it should works with 20.04 LTS.
- ssh access to your servers and able to run as root. NFS server for persistent storage.
- Linux Sysadmin skills

## Ecosystem

We're thinking about Ecosystem so we used 3 mini computers that consume 15w each! Yes 15w!

## What's included

We assumed that you've already know the concepts of Kubernetes cluster by read up on documentation about Kubernetes.
We're providing bootstrap script to help with the process but you need to do it in the right order.
Also, BIG NOTICE that you need to edit the environments to match your need aka: nfs storage resources.

```text
1. Your nodes should be up-to-date with static ip setup before running the bootstrap script.
2. Init the cluster with kubeadm --apiserver-advertise-address=<your-ip-address>
3. Install the CNI network of your choice. (We're using calico)
4. Check master node & join workers to master node
5. Install Portainer to gain control over the cluster in web GUI
6. Install ingress-nginx to be the Load Balancer
7. Install nfs for persistent storage
8. Install kubesphere to gain control of your cluster in web GUI
9. Install KubeVirt if your hardware support it to gain kvm access
```

## Bugs and feature requests

Have a bug or a feature request? Please first read the [issue guidelines](https://reponame/blob/master/CONTRIBUTING.md) and search for existing and closed issues. If your problem or idea is not addressed yet, [please open a new issue](https://reponame/issues/new).
    <a href="https://reponame/issues/new?template=bug.md">Report bug</a>
    <a href="https://reponame/issues/new?template=feature.md&labels=feature">Request feature</a>
## Contributing

Please read through our [contributing guidelines](https://reponame/blob/master/CONTRIBUTING.md). Included are directions for opening issues, coding standards, and notes on development.

Moreover, all HTML and CSS should conform to the [Code Guide](https://github.com/mdo/code-guide), maintained by [Main author](https://github.com/usernamemainauthor).

Editor preferences are available in the [editor config](https://reponame/blob/master/.editorconfig) for easy use in common text editors. Read more and download plugins at <https://editorconfig.org/>.

## Creators

**phamcs**

- <https://github.com/phamcs>

## Thanks

We want everyone beable to setup K8S for learning purposes. As a nerd you need to know this stuff as this technology will dominate deployment process for future.
If you think this is helpful please consider donating for us.

**BTC:** 1H9WXBXWwsu9tWJb5rdE9ZTUU4vae7VLUY

## Copyright and license

Code and documentation copyright 2011-2018 the authors. Code released under the [MIT License](https://reponame/blob/master/LICENSE).

Enjoy :metal:
