#!/bin/bash

## Capture our instance metadata and lookup the namespace tag
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl http://169.254.169.254/latest/meta-data/placement/region)
NAMESPACE=$(aws ec2 describe-tags --filters \
    "Name=resource-type,Values=instance" \
    "Name=resource-id,Values=${INSTANCE_ID}" \
    "Name=key,Values=namespace" \
    --region ${REGION} \
    --output text \
    --query Tags[0].Value)

EFSMOUNT=$(aws ssm get-parameter --name "/${NAMESPACE}/wordpress/efs_mount" --region $REGION --output text --query Parameter.Value)


## Install AWS EFS tools
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
yum install amazon-efs-utils -y

## Create out webroot folder and mount the EFS share into this folder
mkdir -p /var/www/html
echo "${EFSMOUNT}:/ /var/www/html efs _netdev,tls,iam 0 0" >> /etc/fstab
mount -a

## Install out application components and perform a full system update
yum install httpd mysql jq -y
amazon-linux-extras install php7.2
yum update -y

## Check if Wordpress has been downloaded and configured already
if [[ ! -f /var/www/html/wp-config.php ]]
then
    ## Quickly create the wp-config.php file before any other instances can
    touch /var/www/html/wp-config.php

    NAME=$(aws ec2 describe-tags --filters \
        "Name=resource-type,Values=instance" \
        "Name=resource-id,Values=${INSTANCE_ID}" \
        "Name=key,Values=Name" \
        --region ${REGION} \
        --output text \
        --query Tags[0].Value)

    ## Query Secrets Manager for our RDS credentials
    RDS_SECRET=$(aws secretsmanager get-secret-value --secret-id "${NAME}_rds" --region $REGION --output text --query SecretString)
    DBNAME=$(echo $RDS_SECRET | jq -r .database_name)
    ENDPOINT=$(echo $RDS_SECRET | jq -r .endpoint)
    USERNAME=$(echo $RDS_SECRET | jq -r .username)
    PASSWORD=$(echo $RDS_SECRET | jq -r .password)
    
    ## Download and install the latest version of Wordpress
    cd /var/www/html
    wget https://wordpress.org/latest.tar.gz
    tar -zxf latest.tar.gz --strip 1
    rm -f latest.tar.gz
    /usr/bin/cp -f wp-config-sample.php wp-config.php

    ## Update the Wordpress configuration file with our RDS connection details
    sed -i "s/database_name_here/${DBNAME}/g" wp-config.php
    sed -i "s/localhost/${ENDPOINT}/g" wp-config.php
    sed -i "s/username_here/${USERNAME}/g" wp-config.php
    sed -i "s/password_here/${PASSWORD}/g" wp-config.php
fi

## Enable autostart and startup the HTTPD service
chkconfig httpd on
service httpd start
