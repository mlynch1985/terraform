#!/bin/bash

yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on

INSTANCE_ID=$(curl -s 'http://169.254.169.254/latest/meta-data/instance-id')
INSTANCE_REGION=$(curl -s 'http://169.254.169.254/latest/dynamic/instance-identity/document' | python -c "import sys, json; print json.load(sys.stdin)['region']")

if [ ! -d "/opt/aws/amazon-cloudwatch-agent" ]
then
    wget https://s3.${INSTANCE_REGION}.amazonaws.com/amazoncloudwatch-agent-${INSTANCE_REGION}/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
    rpm -U ./amazon-cloudwatch-agent.rpm
    rm -rf amazon-cloudwatch-agent.rpm
fi

export AWS_DEFAULT_REGION=$INSTANCE_REGION

CW_JSON=$(aws ssm get-parameter --region $INSTANCE_REGION --output text --query "Parameter.Value" --name "sample-linuxasg-cloudwatchconfig")
CW_CONFIG="/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json"
CWA_BINARY="/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl"

echo $CW_JSON > $CW_CONFIG

$CWA_BINARY -a fetch-config -m ec2 -c file:$CW_CONFIG -s
