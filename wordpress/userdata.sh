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

APPROLE=$(aws ec2 describe-tags --filters \
    "Name=resource-type,Values=instance" \
    "Name=resource-id,Values=${INSTANCE_ID}" \
    "Name=key,Values=app_role" \
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

## Install out application components
yum install httpd mysql jq -y
amazon-linux-extras install php7.2

## Check if Wordpress has been downloaded and configured already
if [[ ! -f /var/www/html/wp-config.php ]]
then
    ## Quickly create the wp-config.php file before any other instances can
    touch /var/www/html/wp-config.php

    ## Query Secrets Manager for our RDS credentials
    RDS_SECRET=$(aws secretsmanager get-secret-value --secret-id "${NAMESPACE}_${APPROLE}_rds" --region $REGION --output text --query SecretString)
    DBNAME=$(echo $RDS_SECRET | jq -r .database_name)
    ENDPOINT=$(echo $RDS_SECRET | jq -r .endpoint)
    USERNAME=$(echo $RDS_SECRET | jq -r .username)
    PASSWORD=$(echo $RDS_SECRET | jq -r .password)

    ## Query SSM Parameter Store for the ALB DNS
    i=0
    until [ ! -z $ALBDNS ]
    do
        ALBDNS=$(aws ssm get-parameter --name "/${NAMESPACE}/${APPROLE}/alb_dns" --region $REGION --output text --query Parameter.Value)
        ((i=i+1))
        sleep 30

        if [ $i -gt 5 ]
        then
            ALBDNS=""
            break
        fi
    done
    
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
    sed -i "s#<?php#<?php\ndefine( 'WP_HOME', '$ALBDNS' );\ndefine( 'WP_SITEURL', '$ALBDNS' );#g" wp-config.php

    ## Generate new Cookie Seed Keys and update the WP Config file
    echo "" >> wp-config.php
    curl -s 'https://api.wordpress.org/secret-key/1.1/salt/' >> wp-config.php
fi

## Reset permissions on the HTTPD WebRoot
chown -R apache:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

## Enable autostart and startup the HTTPD service
chkconfig httpd on
service httpd start

## Install the CloudwatchAgent if not already present
if [ ! -d "/opt/aws/amazon-cloudwatch-agent" ]
then
    wget https://s3.${REGION}.amazonaws.com/amazoncloudwatch-agent-${REGION}/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
    rpm -U ./amazon-cloudwatch-agent.rpm
    rm -rf amazon-cloudwatch-agent.rpm
fi

## Configure the CloudWatchAgent and start it up
CWA_SOURCE=$(aws ssm get-parameter --name "/${NAMESPACE}/${APPROLE}/cwa_linux_config" --region $REGION --output text --query Parameter.Value)
CWA_CONFIG="/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json"
CWA_BINARY="/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl"

echo $CWA_SOURCE > $CWA_CONFIG
$CWA_BINARY -a fetch-config -m ec2 -c file:$CWA_CONFIG -s

## Perform a full system update
yum update -y