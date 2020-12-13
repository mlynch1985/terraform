#!/bin/bash

## Mount Second Drive
mkfs -t xfs /dev/nvme1n1
mkdir /data
echo "/dev/nvme1n1 /data xfs auto,defaults,nofail 0 2" >> /etc/fstab
mount -a

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

COMPONENT=$(aws ec2 describe-tags --filters \
    "Name=resource-type,Values=instance" \
    "Name=resource-id,Values=${INSTANCE_ID}" \
    "Name=key,Values=component" \
    --region ${REGION} \
    --output text \
    --query Tags[0].Value)

## Install the CloudwatchAgent if not already present
if [ ! -d "/opt/aws/amazon-cloudwatch-agent" ]
then
    wget https://s3.${REGION}.amazonaws.com/amazoncloudwatch-agent-${REGION}/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
    rpm -U ./amazon-cloudwatch-agent.rpm
    rm -rf amazon-cloudwatch-agent.rpm
fi

## Define CloudWatchAgent variables
CWA_SOURCE=$(aws ssm get-parameter --name "/${NAMESPACE}/${COMPONENT}/cwa/linux" --region $REGION --output text --query Parameter.Value)
CWA_CONFIG="/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json"
CWA_BINARY="/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl"

## Setup the CloudWatchAgnet configuration
echo $CWA_SOURCE > $CWA_CONFIG
sed -i "s/NAME_SPACE/${NAMESPACE}_${COMPONENT}/g" $CWA_CONFIG

## Start the CloudWatchAgent
$CWA_BINARY -a fetch-config -m ec2 -c file:$CWA_CONFIG -s

## Configure httpd service
yum install -y httpd
service httpd start
chkconfig httpd on
echo "Hello World!" > /var/www/html/index.html

## Perform a full system update
yum update -y
