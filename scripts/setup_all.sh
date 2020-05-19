#! /bin/bash
#
# Timer:
SECONDS=0

######################
# SOURCE PARAMETERS: #
######################
source params.sh

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

echo "$(tput setaf 2)Script execution time: $SECONDS seconds$(tput sgr 0)"
sudo docker exec -it db3 mariadb -uroot "-prootpass" -e 'select variable_name, variable_value from information_schema.global_status where variable_name in ("wsrep_cluster_size", "wsrep_local_state_comment", "wsrep_cluster_status", "wsrep_incoming_addresses")'
exit 0
