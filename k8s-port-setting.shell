nc localhost 6443
if [ $? -ne 0 ]; then
  firewall-cmd --permanent --add-port=6443/tcp
fi

nc localhost 1025
if [ $? -ne 0 ]; then
  firewall-cmd --permanent --add-port=10250/tcp
fi
