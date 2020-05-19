#!/bin/bash

## Perform system updates first and install some basic components
yum update -y
yum install tmux -y
yum install telnet -y
yum install jq -y

## Capture current Instance ID and Region
INSTANCE_ID=$(curl -s 'http://169.254.169.254/latest/meta-data/instance-id')
INSTANCE_REGION=$(curl -s 'http://169.254.169.254/latest/dynamic/instance-identity/document' | python -c "import sys, json; print json.load(sys.stdin)['region']")

## Install the CloudwatchAgent if not already present
if [ ! -d "/opt/aws/amazon-cloudwatch-agent" ]
then
    wget https://s3.${INSTANCE_REGION}.amazonaws.com/amazoncloudwatch-agent-${INSTANCE_REGION}/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
    rpm -U ./amazon-cloudwatch-agent.rpm
    rm -rf amazon-cloudwatch-agent.rpm
fi

## Update our shell session and set the current region
export AWS_DEFAULT_REGION=$INSTANCE_REGION

## Query EC2 API for namespace instance tag
NAMESPACE=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=namespace" --query 'Tags[0].Value' --output text)

## Define where to download the CloudwatchAgent config from and where to save it
CWA_SOURCE="$NAMESPACE-mltemp/CloudWatchConfigs/linux-amazon-cloudwatch-agent.json"
CWA_DESTINATION="/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json"

## Define where the CloudwatchAgent binary lives
CWA_BINARY="/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl"

## Copy down the CluodWatchAgent config file
aws s3 cp "s3://$CWA_SOURCE" $CWA_DESTINATION

## Configure and start the CloudwatchAgent
$CWA_BINARY -a fetch-config -m ec2 -c file:$CWA_DESTINATION -s

## Install Apache and PHP
yum install httpd -y
amazon-linux-extras install php7.2 -y
yum install php72-gd -y

## Download and extract the latest version of Wordpress
# wget https://wordpress.org/latest.tar.gz
# tar -xzvf latest.tar.gz
# cp wordpress/wp-config-sample.php wordpress/wp-config.php

# cp -r wordpress/* /var/www/html/

# nano /etc/httpd/conf/httpd.conf
#     AllowOverride All

# chown -R apache:apache /var/www

# chmod 2775 /var/www
# find /var/www -type d -exec chmod 2775 {} \;
# find /var/www -type f -exec chmod 0664 {} \;

# systemctl start httpd
# systemctl enable httpd
