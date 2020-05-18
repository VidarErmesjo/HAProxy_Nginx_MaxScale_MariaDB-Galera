#! /bin/bash
#

# openrc:
export OS_USERNAME=dats35
export OS_PASSWORD="race just killed"
export OS_PROJECT_NAME=dats35_project
export OS_IDENTITY_API_VERSION=2
export OS_AUTH_URL=https://cloud.cs.hioa.no:5000/v2.0

# database:
export db_user=$OS_USERNAME
export db_pass=$OS_PASSWORD
export root_password="rootpass"
export maxscaleuser_password="maxscalepass"

# docker image list:
export web_image="richarvey/nginx-php-fpm:latest"
export lb_image="haproxy:latest"
export db_image="mariadb:10.4"
export dbproxy_image="mariadb/maxscale:latest"

# container names:
export web1_container="web1"
export web2_container="web2"
export web3_container="web3"
export lb_container="lb"
export bootstrap_container="bootstrap"
export db1_container="db1"
export db2_container="db2"
export db3_container="db3"
export dbproxy_container="dbproxy"

# hostnames:
export web1_hostname="web1"
export web2_hostname="web2"
export web3_hostname="web3"
export lb_hostname="haproxy"
export bootstrap_hostname="bootstrap"
export db1_hostname="dbgc1"
export db2_hostname="dbgc2"
export db3_hostname="dbgc3"
export dbproxy_hostname="maxscale"

# host IP's:
export web1_IP="172.17.0.2"
export web2_IP="172.17.0.3"
export web3_IP="172.17.0.4"
export lb_IP="172.17.0.5"
export bootstrap_IP="172.17.0.6"
export db1_IP=$bootstrap_IP
export db2_IP="172.17.0.7"
export db3_IP="172.17.0.8"
export dbproxy_IP="172.17.0.9"

# ports:
export lb_port=80

# database:
export db_name="studentinfo"
