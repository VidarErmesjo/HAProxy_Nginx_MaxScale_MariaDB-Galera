#! /bin/bash
if [ ! "$dbproxy_image" ]; then
    echo "Error: Please run main script: setup_all.sh"
    #exit 1
	source params.sh
	sudo docker kill $dbproxy_container
	sudo docker rm $dbproxy_container
fi

#CREATE DATABASE studentinfo;
#USE studentinfo;
#SOURCE /var/lib/mysql/studentinfo-db.sql;
#DROP USER 'root'@'%';
#DROP USER 'maxscaleuser'@'%';
#CREATE USER 'maxscaleuser'@'maxscale' IDENTIFIED BY 'maxscapepass';
#GRANT SELECT ON studentinfo.* TO 'maxscaleuser'@'maxscale' IDENTIFIED BY 'maxscalepass';

#######################
# dbproxy (MaxScale): #
#######################
echo "$(tput setaf 3)MaxScale:$(tput sgr 0)" 
# Files/folders:
sudo mkdir $HOME/volumes/$dbproxy_container 2>/dev/null
sudo cp -a ../webapp/maxscale/. $HOME/volumes/$dbproxy_container 2>/dev/null

# Configure:

# Container:
sudo docker run \
	--detach \
    --name $dbproxy_container \
    --hostname $dbproxy_hostname \
    --add-host $web1_hostname:$web1_IP \
    --add-host $web2_hostname:$web2_IP \
    --add-host $web3_hostname:$web3_IP \
    --add-host $db1_hostname:$db1_IP \
    --add-host $db2_hostname:$db2_IP \
    --add-host $db3_hostname:$db3_IP \
	--publish "3306" \
	--publish "4444" \
	--publish "4567" \
	--publish "4568" \
	$dbproxy_image
sudo docker cp $HOME/volumes/$dbproxy_container/etc/maxscale.cnf $dbproxy_container:/etc/maxscale.cnf
sudo docker restart $dbproxy_container
exit 0
