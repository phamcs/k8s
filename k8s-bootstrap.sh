#!/bin/bash
## Generic installation on all nodes

sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf 
sysctl -p /etc/sysctl.conf

swapoff -a
sed -i '/swap.img/s/^#\?/#/' /etc/fstab 

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf 
overlay 
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1 
net.bridge.bridge-nf-call-ip6tables = 1 
EOF

modprobe overlay
modprobe br_netfilter
sysctl --system
apt-get update && apt-get install -y curl apt-transport-https ca-certificates containerd software-properties-common
mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
systemctl restart containerd && systemctl enable containerd

# Add K8S Stuff
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update && apt install kubernetes-cni -y # not in documentation needed for updates
apt-get install kubelet kubeadm kubectl -y
apt-mark hold kubelet kubeadm kubectl
systemctl daemon-reload && systemctl restart kubelet

## Create Default Audit Policy
mkdir -p /etc/kubernetes
cat > /etc/kubernetes/audit-policy.yaml <<EOF
apiVersion: audit.k8s.io/v1beta1
kind: Policy
rules:
- level: Metadata
EOF

# folder to save audit logs
mkdir -p /var/log/kubernetes/audit

## Install NFS Client Drivers and HELM
apt-get update && apt-get install -y nfs-common
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update && apt-get install -y helm
