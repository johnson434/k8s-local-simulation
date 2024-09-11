#!/usr/bin/env bash

# install packages 
apt-get update

# Docker Install(https://docs.docker.com/engine/install/ubuntu/)
apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker

# Dev tool Install
apt install epel-release -y
apt install vim-enhanced -y
apt install git -y
apt install systemd -y
apt install -y nmap
apt install -y firewalld
apt install net-tools

# K8S Install and Setting(https://kubernetes.io/ko/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
# 6443 포트 열려있는지 확인
apt-get install -y apt-transport-https ca-certificates curl
# 구글 클라우드의 공개 사이닝 키를 다운로드 한다.
curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# 쿠버네티스 apt 리포지터리를 추가한다.
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

# apt 패키지 색인을 업데이트하고, kubelet, kubeadm, kubectl을 설치하고 해당 버전을 고정한다.
apt-get install -y apt-transport-https ca-certificates curl gpg
mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
systemctl enable --now kubelet


# 컨테이너 런타임 세팅(https://kubernetes.io/docs/setup/production-environment/container-runtimes/)
# sysctl params required by setup, params persist across reboots
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF
# Apply sysctl params without reboot
sysctl --system

# cgroup driver 세팅
  # 설명: 프로세스의 자원 제한을 위해 cgroup을 사용하는데
  # kubelet과 container runtime이 동일한 cgroup 드라이버를 써야한다.
  # 사용 가능한 cgroup driver는 cgroupfs랑 systemd가 있다.
  # systemd가 리눅스 기본 cgroup 드라이버라 해당 드라이버 쓰는 게 좋다.
# default로 systemd로 설정되어 있다 그래서 스킵
