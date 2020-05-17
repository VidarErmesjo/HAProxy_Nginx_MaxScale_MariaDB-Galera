#! /bin/bash
#
# All the shell scripts should be fully parameterized to avoid any hard coding of parameter values
# inside the scripts.
# This should be done by placing all the parameters including the openrc
# parameters (ALTO project name, passwords, etc.; no separate openrc file) in a single parameter
# file named as dats35-params.sh; the parameters are accessed from the scripts by sourcing this
# file. ALL THE SCTIPT FILES SHOULD BE RUNNABLE ON ANY UBUNTU 18.04-BASED DOCKER HOST MACHINE JUST
# BY CHANGING THE REQUIRED PARAMETERS IN THE PARAMETER FILE BUT _WITHOUT CHANGING ANY SCRIPT FILE_.
#
# ONLY BASH, PYTHON, AND DOCKER COMMANDS are allowed in the scripts. DOCUMENT SCRIPTS WITH
# APPROPRIATE COMMENTS TO MAKE THE CODE READABLE AND UNDERSTANDABLE.
#
# BE ADVISED NOT TO RUN AND TEST YOUR SCRIPTS IN THE ALREADY WORKING SETUP (IF ALREADY DONE, SAY
# MANUAKKY) IN DATS35-VM TO AVOID MESSING IT UP. USE A VIRTUAL MACHINE IN YOUR LOVAL MACHINE WHEN
# YOU CODE, RUN, AND TEST YOUR SCRIPTS.
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
export db0_container="bootstrap"
export db1_container="db1"
export db2_container="db2"
export db3_container="db3"
export dbproxy_container="dbproxy"

# hostnames:
export web1_hostname="web1"
export web2_hostname="web2"
export web3_hostname="web3"
export lb_hostname="haproxy"
export db0_hostname="dbgc0"
export db1_hostname="dbgc1"
export db2_hostname="dbgc2"
export db3_hostname="dbgc3"
export dbproxy_hostname="maxscale"

# ports:
export lb_port=80

# database:
export db_name="studentinfo"
