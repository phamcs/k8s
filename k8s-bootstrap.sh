#!/usr/bin/bash
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
apt-get update && apt-get install -y wget curl git jq golang automake autoconf coreutils apt-transport-https ca-certificates containerd software-properties-common
mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sed -i 's|^state = ".*"|state = "/var/run/containerd"|' /etc/containerd/config.toml
sed -i '/^\[grpc\]$/,/^\[/ s|^  address = ".*"|  address = "/var/run/containerd/containerd.sock"|' /etc/containerd/config.toml

# Fix deprecate runtime endpoint containerd
sudo tee /etc/crictl.yaml > /dev/null <<EOF
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock
timeout: 2
debug: true
pull-image-on-create: false
EOF

systemctl restart containerd && systemctl enable containerd

# Add K8S Stuff
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor | sudo tee /etc/apt/keyrings/kubernetes-apt-keyring.gpg > /dev/null
apt-get update && apt install -y kubelet kubeadm kubectl kubernetes-cni  # kubernetes-cni not in documentation but needed
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

## Install NFS Client Drivers
apt-get update && apt-get install -y nfs-common
## Install HELM
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update && apt-get install -y helm
## Install Kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
## Install Kompose
curl -L https://github.com/kubernetes/kompose/releases/download/v1.31.2/kompose-linux-amd64 -o kompose
chmod +x kompose
mv ./kompose /usr/local/bin
shutdown -r now
