#! /bin/bash
if [ ! "$dbproxy_image" ]; then
    echo "Error: Please run main script: setup_all.sh"
    exit 1
fi
#######################
# dbproxy (MaxScale): #
#######################
echo "$(tput setaf 3)MaxScale:$(tput sgr 0)" 
# Files/folders:
sudo mkdir $HOME/volumes/$dbproxy_container 2>/dev/null
sudo cp -a ../webapp/dbproxy/. $HOME/volumes/$dbproxy_container 2>/dev/null
# Configure:
# Feed ./webapp/dbproxy/etc/maxscale.cnf from here!!!
# Fetch IP's:
web1_IP=$(sudo docker inspect --format "{{ .NetworkSettings.IPAddress }}" $web1_container)
web2_IP=$(sudo docker inspect --format "{{ .NetworkSettings.IPAddress }}" $web2_container)
web3_IP=$(sudo docker inspect --format "{{ .NetworkSettings.IPAddress }}" $web3_container)
db1_IP=$(sudo docker inspect --format "{{ .NetworkSettings.IPAddress }}" $db1_container)
db2_IP=$(sudo docker inspect --format "{{ .NetworkSettings.IPAddress }}" $db2_container)
db3_IP=$(sudo docker inspect --format "{{ .NetworkSettings.IPAddress }}" $db3_container)
db1_IP="172.17.0.6"
db2_IP="172.17.0.7"
db3_IP="172.17.0.8"
# Container:
sudo docker run \
    --name $dbproxy_container \
    --hostname $dbproxy_hostname \
    --add-host $web1_hostname:$web1_IP \
    --add-host $web2_hostname:$web2_IP \
    --add-host $web3_hostname:$web3_IP \
    --add-host $db1_hostname:$db1_IP \
    --add-host $db2_hostname:$db2_IP \
    --add-host $db3_hostname:$db3_IP \
	--publish-all \
    --detach $dbproxy_image
sudo docker cp $HOME/volumes/$dbproxy_container/etc/maxscale.cnf $dbproxy_container:/etc/maxscale.cnf
sudo docker restart $dbproxy_container
exit 0
