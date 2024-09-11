#!/usr/bin/env bash

NODE_TYPE="$1"

./config.sh
./k8s-port-setting.shell
sudo usermod -G docker vagrant

if [ $NODE_TYPE -eq "MASTER" ]; then
	./master_node.sh
	./helm-install.sh
elif [ $NODE_TYPE -eq "WORKER" ]; then
	./work_nodes.sh
fi
