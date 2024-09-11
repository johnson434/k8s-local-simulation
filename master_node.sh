#!/usr/bin/env bash


# init kubernetes 
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

# https://k21academy.com/docker-kubernetes/container-runtime-is-not-running/
# containerd 사용 시에 발생하는 문제 해결
rm /etc/containerd/config.toml
systemctl restart containerd

KUBE_NODE_TOKEN="a1d51d.1043jfkd1ls35dfn"
kubeadm init --token $KUBE_NODE_TOKEN --token-ttl 0 \
--pod-network-cidr=172.16.0.0/16 --apiserver-advertise-address=$KUBE_API_SERVER --control-plane-endpoint=cluster-endpoint
export KUBECONFIG=/etc/kubernetes/admin.conf

# CNI 설정(Calico)
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/custom-resources.yaml

# install bash-completion for kubectl 
apt install bash-completion -y 

# kubectl completion on bash-completion dir
kubectl completion bash >/etc/bash_completion.d/kubectl

# alias kubectl to k 
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc
