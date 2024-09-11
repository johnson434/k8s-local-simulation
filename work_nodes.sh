#!/usr/bin/env bash

# config for work_nodes only 
echo "[work_nodes.sh]"
systemctl is-active --quiet kubelet
if (($? != 0)); then
  systemctl enable kubelet
  systemctl start kubelet
fi

rm -rf /etc/containerd/config.toml
systemctl restart containerd
kubeadm reset -f

KUBE_NODE_TOKEN="a1d51d.1043jfkd1ls35dfn"
kubeadm join m-k8s:6443 --token $KUBE_NODE_TOKEN --discovery-token-unsafe-skip-ca-verification
export KUBECONFIG=/etc/kubernetes/admin.conf

# 칼리코 설정  
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/custom-resources.yaml

curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/calico.yaml -O
kubectl apply -f calico.yaml

