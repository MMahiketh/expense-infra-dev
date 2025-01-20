#! /bin/bash

INSTANCE=$1
ENV=$2
MYSQL_PASS=$3

sudo dnf install ansible -y

ansible-pull -U https://github.com/MMahiketh/ans-roles-proj.git -C terraform-ansible-2.0 main.yml -e instance=${INSTANCE} -e ENV=${ENV} -e MYSQL_PASS=${MYSQL_PASS}


#:::Clone and run:::
    
    #cd /tmp/

    #git clone --single-branch --branch terraform-ansible-2.0 https://github.com/MMahiketh/ans-roles-proj.git

    #cd ans-roles-proj/

    #https://github.com/MMahiketh/ans-roles-proj.git?ref=terraform-ansible-2.0

    #export ANSIBLE_HOST_KEY_CHECKING=False

    #ansible-playbook main.yml -e INSTANCE=${INSTANCE} -e ENV=${ENV} -e MYSQL_PASS=${MYSQL_PASS}