#! /bin/bash

NODE_TYPE="$1"

# sudo apt update
# sudo apt install git

REPOSITORY_NAME=k8s-local-simulation
REPOSITORY_URL=https://github.com/johnson434/${REPOSITORY_NAME}.git
# git clone $REPOSITORY_URL 

echo $(whoami)

USER_NAME=vagrant
cd ${REPOSITORY_NAME}
for f in ./*.sh; do
	echo "file name: $f"
	chmod +x "$f"
done

export NODE_COUNT=3
source ./config.sh 
source ./k8s-port-setting.sh
source ./install_pkg.sh
sudo usermod -G docker vagrant

if [ $NODE_TYPE = "MASTER" ]; then
	source ./master_node.sh
	source ./helm-install.sh
elif [ $NODE_TYPE = "WORKER" ]; then
	source ./work_nodes.sh
fi
