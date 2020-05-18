 #! /bin/bash
if [ ! "$db_image" ]; then
    echo "Error: Please run main script: setup_all.sh"
    exit 1
fi

#	--env MYSQL_USER=maxscaleuser \
#	--env MYSQL_PASSWORD=maxscalepass \



#####################
# db1 (MariaDB #1): #
#####################
echo "$(tput setaf 3)MariaDB #1:$(tput sgr 0)"
# Files/folder:
sudo mkdir $HOME/volumes/$db1_container 2>/dev/null
sudo cp -a ../webapp/mariadb/. $HOME/volumes/$db1_container 2>/dev/null

# Configure:
echo wsrep_cluster_address=gcomm://$db1_hostname,$db2_hostname,$db3_hostname >> $HOME/volumes/$db1_container/etc/mysql/mariadb.conf.d/galera.cnf
echo wsrep_node_address=$db1_hostname >> $HOME/volumes/$db1_container/etc/mysql/mariadb.conf.d/galera.cnf
echo wsrep_node_name=$db1_container >> $HOME/volumes/$db1_container/etc/mysql/mariadb.conf.d/galera.cnf

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
	$db_image --wsrep-new-cluster
		#--wsrep-cluster-address=gcomm://$db1_hostname,$db2_hostname,$db3_hostname \
		#--wsrep-sst-auth="root:rootpass" \
		#--wsrep-node-address=$db1_hostname \
		#--wsrep-node-name=$db1_container \
		#--wsrep-new-cluster

# Wait for server to start:
echo -n "$(tput setaf 3)Waiting$(tput sgr 0)"
while [ ! "$(sudo docker exec $db1_container mysqladmin ping --user=root --password=rootpass --host=$db1_hostname)" = "mysqld is alive" ]; do
	echo -n "$(tput setaf 3).$(tput sgr 0)"
	sleep 1s
done 2>/dev/null
echo
sudo docker exec $db1_container mariadb-admin ping --user=root --password=rootpass --host=$db1_hostname
#sudo sed -i 's/safe_to_bootstrap: 0/safe_to_bootstrap: 1/g' $HOME/volumes/$db1_container/var/lib/mysql/grastate.dat

#sudo docker exec $db1_container mariadb --user=root --password=rootpass < ../webapp/database/mariadb-secure-installation.sql 

#####################
# db2 (MariaDB #2): #
#####################
echo "$(tput setaf 3)MariaDB #2:$(tput sgr 0)" 
# Files/folder:
sudo mkdir $HOME/volumes/$db2_container 2>/dev/null
sudo cp -a ../webapp/mariadb/. $HOME/volumes/$db2_container 2>/dev/null

# Configure:
echo wsrep_cluster_address=gcomm://$db1_hostname,$db2_hostname,$db3_hostname >> $HOME/volumes/$db2_container/etc/mysql/mariadb.conf.d/galera.cnf
echo wsrep_node_address=$db2_hostname >> $HOME/volumes/$db2_container/etc/mysql/mariadb.conf.d/galera.cnf
echo wsrep_node_name=$db2_container >> $HOME/volumes/$db2_container/etc/mysql/mariadb.conf.d/galera.cnf

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
	$db_image #\
		#--wsrep-cluster-address=gcomm://$db1_hostname,$db2_hostname,$db3_hostname \
		#--wsrep-sst-auth="root:rootpass" \
		#--wsrep-node-address=$db2_hostname \
		#--wsrep-node-name=$db2_container

#####################
# db3 (MariaDB #3): #
#####################
echo "$(tput setaf 3)MariaDB #3:$(tput sgr 0)" 
# Files/folder:
sudo mkdir $HOME/volumes/$db3_container 2>/dev/null
sudo cp -a ../webapp/mariadb/. $HOME/volumes/$db3_container 2>/dev/null

# Configure:
echo wsrep_cluster_address=gcomm://$db1_hostname,$db2_hostname,$db3_hostname >> $HOME/volumes/$db3_container/etc/mysql/mariadb.conf.d/galera.cnf
echo wsrep_node_address=$db3_hostname >> $HOME/volumes/$db3_container/etc/mysql/mariadb.conf.d/galera.cnf
echo wsrep_node_name=$db3_container >> $HOME/volumes/$db3_container/etc/mysql/mariadb.conf.d/galera.cnf

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
	$db_image #\
		#--wsrep-cluster-address=gcomm://$db1_hostname,$db2_hostname,$db3_hostname \
		#--wsrep-sst-auth="root:rootpass" \
		#--wsrep-node-address=$db3_hostname \
		#--wsrep-node-name=$db3_container

#echo "$(tput setaf 3)Setting up Galera Cluster:$(tput sgr 0)"
#sudo docker start $db1_container
#while [ ! "$(sudo docker ps -aq -f status=running -f name=$db1_container)" ]; do
#	echo -n "$(tput setaf 3).$(tput sgr 0)"
#	sleep 1s
#done
echo
#sudo docker exec $db1_container mariadbd --wsrep-new-cluster
# Wait for server to start:
#echo -n "$(tput setaf 3)Waiting$(tput sgr 0)"
#while [ ! "$(sudo docker exec $db1_container mysqladmin ping --user=root --password=rootpass --host=$db1_hostname)" = "mysqld is alive" ]; do
#	echo -n "$(tput setaf 3).$(tput sgr 0)"
#	sleep 1s
#done 2>/dev/null
echo
#sudo docker exec $db1_container mariadb-admin ping --user=root --password=rootpass --host=$db1_hostname
#sudo docker exec $db1_container mariadb --user=root --password=rootpass < ../webapp/database/mariadb-secure-installation.sql 

echo -n "$(tput setaf 3)Waiting$(tput sgr 0)" 
while	[ ! "$(sudo docker ps -qa -f status=exited -f name=$db2_container)" ] && \
		[ ! "$(sudo docker ps -qa -f status=exited -f name=$db3_container)" ]; do
	echo -n "$(tput setaf 3).$(tput sgr 0)"
	sleep 1
done 2>/dev/null
echo
sudo docker start $db2_container $db3_container
#sudo docker exec $db2_container mariadb --user=root --password=rootpass < ../webapp/database/mariadb-secure-installation.sql 
#sudo docker exec $db3_container mariadb --user=root --password=rootpass < ../webapp/database/mariadb-secure-installation.sql 
exit 0
