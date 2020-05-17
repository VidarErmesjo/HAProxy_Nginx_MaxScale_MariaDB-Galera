 #! /bin/bash
if [ ! "$db_image" ]; then
    echo "Error: Please run main script: setup_all.sh"
    exit 1
fi

#############
# Set IP's: #
#############
#db0_IP="172.17.0.6"
db1_IP="172.17.0.6"
db2_IP="172.17.0.7"
db3_IP="172.17.0.8"

##############
# bootstrap: #
##############
echo "$(tput setaf 3)Bootstraping Galera Cluster:$(tput sgr 0)"
# Files/folder:
sudo mkdir $HOME/volumes/$db1_container 2>/dev/null
sudo cp -a ../webapp/mariadb/. $HOME/volumes/$db1_container 2>/dev/null
# Container:
sudo docker run \
	--detach \
	--name $db1_container \
	--hostname $db1_hostname \
    --add-host $db2_container:$db2_IP \
    --add-host $db3_container:$db3_IP \
	--publish "3306" \
	--publish "4444" \
	--publish "4567" \
	--publish "4568" \
	--env MYSQL_ROOT_PASSWORD=rootpass \
	--env MYSQL_USER=maxscaleuser \
	--env MYSQL_PASSWORD=maxscalepass \
	--volume $HOME/volumes/$db1_container/etc/mysql:/etc/mysql \
	--volume $HOME/volumes/$db1_container/var/lib/mysql:/var/lib/mysql \
	$db_image \
		--wsrep-cluster-address=gcomm:// \
		--wsrep-sst-auth="root:rootpass" \
		--wsrep-node-address=$db1_hostname \
		--wsrep-node-name=$db1_container \
# Wait:
echo -n "$(tput setaf 3)Waiting for bootstrap to finish$(tput sgr 0)"
while [ ! "$(sudo docker exec $db1_container mysqladmin ping --user=root --password=rootpass --host=$db1_hostname)" = "mysqld is alive" ]; do
	echo -n "$(tput setaf 3).$(tput sgr 0)"
	sleep 1s
done 2>/dev/null
echo
sudo docker exec $db1_container mysqladmin ping --user=root --password=rootpass --host=$db1_hostname

#####################
# db2 (MariaDB #2): #
#####################
echo "$(tput setaf 3)MariaDB #2:$(tput sgr 0)" 
# Files/folder:
sudo mkdir $HOME/volumes/$db2_container 2>/dev/null
sudo cp -a ../webapp/mariadb/. $HOME/volumes/$db2_container 2>/dev/null

# Container:
sudo docker run \
	--detach \
	--name $db2_container \
    --hostname $db2_hostname \
	--add-host $db1_hostname:$db1_IP \
	--add-host $db3_hostname:$db3_IP \
	--publish "3306" \
	--publish "4444" \
	--publish "4567" \
	--publish "4568" \
    --env MYSQL_ROOT_PASSWORD=rootpass \
	--volume $HOME/volumes/$db2_container/etc/mysql:/etc/mysql \
	--volume $HOME/volumes/$db2_container/var/lib/mysql:/var/lib/mysql \
    $db_image \
		--wsrep-cluster-address=gcomm://$db0_hostname,$db1_hostname,$db2_hostname,$db3_hostname \
		--wsrep-sst-auth="root:rootpass" \
		--wsrep-node-address=$db2_hostname \
		--wsrep-node-name=$db2_container
sudo cp -a ../webapp/database/. $HOME/volumes/$db2_container/var/lib/mysql 2>/dev/null

#####################
# db3 (MariaDB #3): #
#####################
echo "$(tput setaf 3)MariaDB #3:$(tput sgr 0)" 
# Files/folder:
sudo mkdir $HOME/volumes/$db3_container 2>/dev/null
sudo cp -a ../webapp/mariadb/. $HOME/volumes/$db3_container 2>/dev/null

# Container:
sudo docker run \
	--detach \
    --name $db3_container \
    --hostname $db3_hostname \
    --add-host $db1_hostname:$db1_IP \
    --add-host $db2_hostname:$db2_IP \
	--publish "3306" \
	--publish "4444" \
	--publish "4567" \
	--publish "4568" \
    --env MYSQL_ROOT_PASSWORD=rootpass \
    --volume $HOME/volumes/$db3_container/etc/mysql:/etc/mysql \
    --volume $HOME/volumes/$db3_container/var/lib/mysql:/var/lib/mysql \
    $db_image \
		--wsrep-cluster-address=gcomm://$db0_hostname,$db1_hostname,$db2_hostname,$db3_hostname \
		--wsrep-sst-auth="root:rootpass" \
		--wsrep-node-address=$db3_hostname \
		--wsrep-node-name=$db3_container
sudo cp -a ../webapp/database/. $HOME/volumes/$db3_container/var/lib/mysql 2>/dev/null

echo -n "$(tput setaf 3)Waiting for containers to exit$(tput sgr 0)" 
while	[ ! "$(sudo docker ps -qa -f status=exited -f name=$db2_container)" ] && \
		[ ! "$(sudo docker ps -qa -f status=exited -f name=$db3_container)" ]; do
	echo -n "$(tput setaf 3).$(tput sgr 0)"
	sleep 1
done 2>/dev/null
echo
#sudo docker kill -s 15 $db0_container
#sudo docker kill $db0_container
#sudo docker rm $db0_container
#sudo sed -i 's/safe_to_bootstrap: 0/safe_to_bootstrap: 1/g' ~/volumes/$db1_container/var/lib/mysql/grastate.dat
#sudo cat $HOME/volumes/$db1_container/var/lib/mysql/grastate.dat

#####################
# db1 (MariaDB #1): #
#####################
#echo "$(tput setaf 3)MariaDB #1:$(tput sgr 0)"
# Files/folder:
#sudo mkdir $HOME/volumes/$db1_container 2>/dev/null
#sudo cp -a ../webapp/mariadb/. $HOME/volumes/$db1_container 2>/dev/null
# Container:
#sudo docker run \
#	--detach \
#	--name $db1_container \
#    --hostname $db1_hostname \
#    --add-host $db0_hostname:$db0_IP \
#	--add-host $db2_hostname:$db2_IP \
#	--add-host $db3_hostname:$db3_IP \
#	--publish "3306" \
#	--publish "4444" \
#	--publish "4567" \
#	--publish "4568" \
#	--env MYSQL_ROOT_PASSWORD=rootpass \
#   --volume $HOME/volumes/$db1_container/etc/mysql:/etc/mysql \
#	--volume $HOME/volumes/$db1_container/var/lib/mysql:/var/lib/mysql \
#    $db_image \
#		--wsrep-cluster-address=gcomm://$db0_hostname,$db1_hostname,$db2_hostname,$db3_hostname \
#		--wsrep-sst-auth="root:rootpass" \
#		--wsrep-node-address=$db1_hostname \
#		--wsrep-node-name=$db1_container
#sudo cp -a ../webapp/database/. $HOME/volumes/$db1_container/var/lib/mysql 2>/dev/null

sudo docker start $db2_container $db3_container

###################
# Setup database: #
###################
#sudo docker exec $db1_container mariadb --user=root --password='$rootpass' --execute="CREATE DATABASE studentinfo"
#sudo docker exec $db1_container mariadb --user=root --password='$rootpass' --execute="USE studentinfo"
#sudo docker exec $db1_container mariadb --user=root --password='$rootpass' --execute="SOURCE /var/lib/mysql/studentinfo-db.sql"
#sudo docker start $db2_container $db3_container
exit 0
