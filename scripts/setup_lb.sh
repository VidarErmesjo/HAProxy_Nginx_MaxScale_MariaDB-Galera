#! /bin/bash
if [ ! "$lb_image" ]; then
    echo "Error: Please run main script: setup_all.sh"
    exit 1
fi
#################
# lb (HAProxy): #
#################
echo "$(tput setaf 3)HAProxy:$(tput sgr 0)" 
# Files/folders:
sudo mkdir $HOME/volumes/$lb_container 2>/dev/null
sudo cp -a ../webapp/haproxy/. $HOME/volumes/$lb_container 2>/dev/null
# Configure:
echo "  server webserver1 $web1_hostname:80 check" \
        >> $HOME/volumes/$lb_container/haproxy.cfg 2>/dev/null
echo "  server webserver2 $web2_hostname:80 check" \
    >> $HOME/volumes/$lb_container/haproxy.cfg 2>/dev/null
echo "  server webserver3 $web3_hostname:80 check" \
    >> $HOME/volumes/$lb_container/haproxy.cfg 2>/dev/null
# Fetch IP's:
web1_IP=$(sudo docker inspect --format "{{ .NetworkSettings.IPAddress }}" $web1_container) 2>/dev/null
web2_IP=$(sudo docker inspect --format "{{ .NetworkSettings.IPAddress }}" $web2_container) 2>/dev/null
web3_IP=$(sudo docker inspect --format "{{ .NetworkSettings.IPAddress }}" $web3_container) 2>/dev/null
# Container:
sudo docker run \
        --name $lb_container \
        --hostname $lb_hostname \
        --add-host $web1_hostname:$web1_IP \
        --add-host $web2_hostname:$web2_IP \
        --add-host $web3_hostname:$web3_IP \
        --volume $HOME/volumes/$lb_container:/usr/local/etc/haproxy:ro \
        --publish $lb_port:80 \
        --detach $lb_image 2>/dev/null
exit 0
