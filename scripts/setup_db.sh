 #! /bin/bash
if [ ! "$db_image" ]; then
    echo "Error: Please run main script: setup_all.sh"
    exit 1
fi

#####################
# db1 (MariaDB #1): #
#####################
echo "$(tput setaf 3)MariaDB #1:$(tput sgr 0)"
# Files/folder:
sudo mkdir $HOME/volumes/$db1_container 2>/dev/null
sudo cp -a ../webapp/mariadb/. $HOME/volumes/$db1_container 2>/dev/null
sudo cp -a ../webapp/database/. $HOME/volumes/$db1_container/var/lib/mysql 2>/dev/null
#	--env MYSQL_USER=maxscaleuser \
#	--env MYSQL_PASSWORD=maxscalepass \

# Container:
sudo docker run \
	--detach \
	--name $db1_container \
	--hostname $db1_hostname \
    --add-host $db2_hostname:$db2_IP \
    --add-host $db3_hostname:$db3_IP \
	--publish "3306" \
	--publish "4444" \
	--publish "4567" \
	--publish "4568" \
	--env MYSQL_ROOT_PASSWORD=rootpass \
	--volume $HOME/volumes/$db1_container/etc/mysql:/etc/mysql \
	--volume $HOME/volumes/$db1_container/var/lib/mysql:/var/lib/mysql \
	$db_image \
		--wsrep-cluster-address=gcomm://$db1_hostname,$db2_hostname,$db3_hostname \
		--wsrep-sst-auth="root:rootpass" \
		--wsrep-node-address=$db1_hostname \
		--wsrep-node-name=$db1_container \
		--wsrep-new-cluster \

# Wait for server to start:
echo -n "$(tput setaf 3)Waiting for $db1_container to finish$(tput sgr 0)"
while [ ! "$(sudo docker exec $db1_container mysqladmin ping --user=root --password=rootpass --host=$db1_hostname)" = "mysqld is alive" ]; do
	echo -n "$(tput setaf 3).$(tput sgr 0)"
	sleep 1s
done 2>/dev/null
echo
sudo docker exec $db1_container mariadb-admin ping --user=root --password=rootpass --host=$db1_hostname

#sudo docker exec -it $db1_container mariadb-secure-installation
#mariadb="mariadb --user=root --password=rootpass"
#sudo docker exec $db1_container $mariadb --execute="ALTER USER 'root'@'localhost' IDENTIFIED BY 'rootpass'"
#sudo docker exec $db1_container $mariadb --execute="UPDATE mysql.user SET Password=PASSWORD('rootpass') WHERE User='root'"
#sudo docker exec $db1_container $mariadb --execute="DELETE FROM mysql.user WHERE User=''"
#sudo docker exec $db1_container $mariadb --execute="DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
#sudo docker exec $db1_container $mariadb --execute="DROP DATABASE IF EXISTS test"
#sudo docker exec $db1_container $mariadb --execute="DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
#sudo docker exec $db1_container $mariadb --execute="FLUSH PRIVILEGES"

#####################
# db2 (MariaDB #2): #
#####################
echo "$(tput setaf 3)MariaDB #2:$(tput sgr 0)" 
# Files/folder:
sudo mkdir $HOME/volumes/$db2_container 2>/dev/null
sudo cp -a ../webapp/mariadb/. $HOME/volumes/$db2_container 2>/dev/null
sudo cp -a ../webapp/database/. $HOME/volumes/$db2_container/var/lib/mysql 2>/dev/null

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
		--wsrep-cluster-address=gcomm://$db1_hostname,$db2_hostname,$db3_hostname \
		--wsrep-sst-auth="root:rootpass" \
		--wsrep-node-address=$db2_hostname \
		--wsrep-node-name=$db2_container

#####################
# db3 (MariaDB #3): #
#####################
echo "$(tput setaf 3)MariaDB #3:$(tput sgr 0)" 
# Files/folder:
sudo mkdir $HOME/volumes/$db3_container 2>/dev/null
sudo cp -a ../webapp/mariadb/. $HOME/volumes/$db3_container 2>/dev/null
sudo cp -a ../webapp/database/. $HOME/volumes/$db3_container/var/lib/mysql 2>/dev/null

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
		--wsrep-cluster-address=gcomm://$db1_hostname,$db2_hostname,$db3_hostname \
		--wsrep-sst-auth="root:rootpass" \
		--wsrep-node-address=$db3_hostname \
		--wsrep-node-name=$db3_container

echo -n "$(tput setaf 3)Waiting for $db2_container and $db3_container to exit$(tput sgr 0)" 
while	[ ! "$(sudo docker ps -qa -f status=exited -f name=$db2_container)" ] && \
		[ ! "$(sudo docker ps -qa -f status=exited -f name=$db3_container)" ]; do
	echo -n "$(tput setaf 3).$(tput sgr 0)"
	sleep 1
done 2>/dev/null
echo
sudo docker start $db2_container $db3_container

###################
# Setup database: #
###################
#sudo docker exec $db1_container mariadb --user=root --password='$rootpass' --execute="CREATE DATABASE studentinfo"
#sudo docker exec $db1_container mariadb --user=root --password='$rootpass' --execute="USE studentinfo"
#sudo docker exec $db1_container mariadb --user=root --password='$rootpass' --execute="SOURCE /var/lib/mysql/studentinfo-db.sql"
#sudo docker start $db2_container $db3_container
exit 0
