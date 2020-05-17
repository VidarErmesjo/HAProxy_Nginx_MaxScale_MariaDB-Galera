#! /bin/bash
if [ ! "$web_image" ]; then
	echo "Error: Please run main script: setup_all.sh"
	exit 1
fi
dbproxy_IP="172.17.0.9"
####################
# web1 (Nginx #1): #
####################
echo "$(tput setaf 3)Nginx #1:$(tput sgr 0)"
# Files/folders:
sudo mkdir $HOME/volumes/$web1_container 2>/dev/null
sudo mkdir $HOME/volumes/$web1_container/web 2>/dev/null
sudo mkdir $HOME/volumes/$web1_container/web/html 2>/dev/null
sudo cp -a ../webapp/phpcode/. $HOME/volumes/$web1_container/web/html 2>/dev/null
# Container:
sudo docker run \
    --name $web1_container \
    --hostname $web1_hostname \
	--add-host $dbproxy_hostname:$dbproxy_IP \
    --volume $HOME/volumes/$web1_container/web/html:/var/www/html \
    --detach $web_image
####################
# web2 (Nginx #2): #
####################
echo "$(tput setaf 3)Nginx #2:$(tput sgr 0)" 
# Files/folders:
sudo mkdir $HOME/volumes/$web2_container 2>/dev/null
sudo mkdir $HOME/volumes/$web2_container/web 2>/dev/null
sudo mkdir $HOME/volumes/$web2_container/web/html 2>/dev/null
sudo cp -a ../webapp/phpcode/. $HOME/volumes/$web2_container/web/html 2>/dev/null
# Container:
sudo docker run \
    --name $web2_container \
    --hostname $web2_hostname \
    --volume $HOME/volumes/$web2_container/web/html:/var/www/html \
	--add-host $dbproxy_hostname:$dbproxy_IP \
    --detach $web_image
####################
# web3 (Nginx #3): #
####################
echo "$(tput setaf 3)Nginx #3:$(tput sgr 0)" 
# Files/folders:
sudo mkdir $HOME/volumes/$web3_container 2>/dev/null
sudo mkdir $HOME/volumes/$web3_container/web 2>/dev/null
sudo mkdir $HOME/volumes/$web3_container/web/html 2>/dev/null
sudo cp -a ../webapp/phpcode/. $HOME/volumes/$web3_container/web/html 2>/dev/null
# Container:
sudo docker run \
    --name $web3_container \
    --hostname $web3_hostname \
	--add-host $dbproxy_hostname:$dbproxy_IP \
    --volume $HOME/volumes/$web3_container/web/html:/var/www/html \
	--detach $web_image
exit 0
