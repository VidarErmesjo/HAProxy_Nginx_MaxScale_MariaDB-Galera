#! /bin/bash
#
#################################
# PORTFOLIO EXAM 2 BY GROUP 35: #
#################################
#
# The script file setup_all.sh should run all the tasks in a proper order to do all the
# tasks automatically without any manual intervention (you can have separate script files for
# different tasks and call them in the setup_all.sh). THE CLOUD SETUP (TASKS 2 TO 5) CREATED BY
# RUNNING THIS SCRIPT WILL BE CHECKED AND EVALUATED (NO SEPARATE CHECKS WILL BE DOE BY RUNNING
# OTHER INDIVIDUAL SCRIPT FILES IF YOU HAVE). THEREFORE, MAKE SURE THAT ALL POSSIBLE ERRORS ARE HANDLED
# PROPERLY SO THAT ALL THE WORKING SCRIPTS RUN, AND NON-WORKING SCRIPTS ARE SKIPPED OR IGNORED WITH
# PROPER MESSAGES IN THE MAIN SCRIPT FILE, setup_all.sh.
#
# Timer:
SECONDS=0

######################
# SOURCE PARAMETERS: #
######################
source dats35-params.sh

########################
# PRUNE SETUP & RESET: #
########################
echo "$(tput setaf 3)Pruning and resetting:$(tput sgr 0)"
# Docker:
sudo docker container kill web1 web2 web3 lb dbproxy db1 db2 db3 bootstrap 2>/dev/null
sudo docker container prune --force 2>/dev/null
if [ "$1" = "--full-reset" ]; then
	sudo docker image rm $web_image $lb_image $db_image $dbproxy_image 2>/dev/null
fi
sudo system prune --force 2>/dev/null
# Files/folders:
sudo rm -R $HOME/volumes 2>/dev/null
sudo mkdir $HOME/volumes 2>/dev/null

#######################
# PULL DOCKER IMAGES: #
#######################
echo "$(tput setaf 3)Inspect Docker images:$(tput sgr 0)"
if [ ! "$(sudo docker image inspect --format "{{ .RepoTags }}" $web_image)" = "[$web_image]" ]; then
	sudo docker pull $web_image
fi
if [ ! "$(sudo docker image inspect --format "{{ .RepoTags }}" $lb_image)" = "[$lb_image]" ]; then
	sudo docker pull $lb_image
fi
if [ ! "$(sudo docker image inspect --format "{{ .RepoTags }}" $db_image)" = "[$db_image]" ]; then
	sudo docker pull $db_image
fi
if [ ! "$(sudo docker image inspect --format "{{ .RepoTags }}" $dbproxy_image)" = "[$dbproxy_image]" ]; then
	sudo docker pull $dbproxy_image
fi

#####################
# SETUP WEB SERVERS #
#####################
# Run script:
./setup_web.sh

########################
# SETUP LOAD BALANCER: #
########################
# Run script:
./setup_lb.sh

####################
# SETUP DATABASES: #
####################
# Run script:
./setup_db.sh

#########################
# SETUP DATABASE PROXY: #
#########################
# Run script:
./setup_dbproxy.sh

#######################
# DEBUGING & TESTING: #
#######################
echo ""
echo "$(tput setaf 2)Script execution time: $SECONDS seconds$(tput sgr 0)"
#sudo docker exec $db1_container mariadb --user=root --password=$rootpass --execute="SHOW STATUS LIKE 'wsrep_cluster_size'"
#sudo docker exec $db1_container mariadb --user=root --password=$rootpass --execute="CREATE DATABASE studentinfo"
#sudo docker exec $db1_container mariadb --user=root --password=$rootpass --execute="USE studentinfo"
#sudo docker exec $db1_container mariadb --user=root --password=$rootpass --execute="SOURCE /var/lib/mysql/studentinfo-db.sql"
#sudo docker exec $db1_container mariadb --user=root --password=$rootpass --execute="USE studentinfo; SELECT * FROM postaltable"
#sudo docker exec $db1_container mariadb --user=root --password=$rootpass --execute="USE studentinfo; SELECT * FROM students"
#sudo docker exec $db1_container mariadb --user=root --password=$rootpass --execute="USE studentinfo; SELECT * FROM degree"
#sudo docker exec $db1_container mariadb --user=root --password=$rootpass --execute="SHOW STATUS LIKE 'wsrep_cluster_size'"
exit 0
