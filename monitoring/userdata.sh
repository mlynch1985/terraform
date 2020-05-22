#!/bin/bash

## Perform system updates first and install some basic components
yum update -y

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


## Install Base Elastic Search Components
amazon-linux-extras install java-openjdk11 -y

## Add the Elastic Search Repository
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

cat >> /etc/yum.repos.d/elasticsearch.repo <<EOF
[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md
EOF


## Capture Current Local IP Address
LOCAL_IP=$(hostname -I)

## Install latest version of ElasticSearch
yum install --enablerepo=elasticsearch elasticsearch -y
yum install --enablerepo=elasticsearch kibana -y
yum install --enablerepo=elasticsearch logstash -y

## Configure ElasticSearch
sed -i "s/#cluster.name: my-application/cluster.name: $NAMESPACE-Cluster/g" /etc/elasticsearch/elasticsearch.yml
sed -i "s/#node.name: node-1/node.name: $INSTANCE_ID/g" /etc/elasticsearch/elasticsearch.yml
sed -i "s/#network.host: 192.168.0.1/network.host: 0.0.0.0/g" /etc/elasticsearch/elasticsearch.yml
sed -i "s/#http.port: 9200/http.port: 9200/g" /etc/elasticsearch/elasticsearch.yml
sed -i "s/#discovery.seed_hosts: \[\"host1\", \"host2\"\]/discovery.seed_hosts: \[\"$LOCAL_IP\"\]/g" /etc/elasticsearch/elasticsearch.yml
sed -i "s/#cluster.initial_master_nodes: \[\"node-1\", \"node-2\"\]/cluster.initial_master_nodes: \[\"$INSTANCE_ID\"\]/g" /etc/elasticsearch/elasticsearch.yml

## Setup ElasticSearch to be autostart services
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service

## Start ElasticSearch
systemctl start elasticsearch.service


## Configure Kibana
sed -i "s/#server.port: 5601/server.port: 5601/g" /etc/kibana/kibana.yml
sed -i "s/#server.host: \"localhost\"/server.host: \"0.0.0.0\"/g" /etc/kibana/kibana.yml
sed -i "s/#server.name: \"your-hostname\"/server.name: \"$INSTANCE_ID\"/g" /etc/kibana/kibana.yml
sed -i "s/#elasticsearch.hosts: \[\"http:\/\/localhost:9200\"\]/elasticsearch.hosts: \[\"http:\/\/localhost:9200\"\]/g" /etc/kibana/kibana.yml
sed -i "s//g" /etc/kibana/kibana.yml

## Setup Kibana to be autostart services
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service

## Start Kibana
systemctl start kibana.service


## Configre Logstash
/usr/share/logstash/bin/logstash-plugin install logstash-input-kinesis
/usr/share/logstash/bin/logstash-plugin install logstash-input-cloudwatch
/usr/share/logstash/bin/logstash-plugin install logstash-codec-cloudwatch_logs

cat > /etc/logstash/conf.d/windows-eventlogs.conf <<EOF
input {
  kinesis {
    kinesis_stream_name => "${NAMESPACE}_windows_eventlogs"
    codec => cloudwatch_logs
    tags => ["windows_eventlogs"]
  }
}
filter {
    if "windows_eventlogs" in [tags] {
        xml {
            source => "message"
            target => "parsed"
            remove_field => "message"
        }
    }
}
output {
    if "windows_eventlogs" in [tags] {
        elasticsearch {
            index => "windows-eventlogs"
        }
    }
}
EOF

cat > /etc/logstash/conf.d/cloudwatch-metrics.conf <<EOF
input {
  cloudwatch {
      namespace => "AWS/EC2"
      metrics => ["CPUUtilization"]
      region => "${INSTANCE_REGION}"
      tags => ["cloudwatch_metrics"]
  }
}
output {
    if "cloudwatch_metrics" in [tags] {
        elasticsearch {
            index => "cloudwatch-metrics"
        }
    }
}
EOF

## Setup Logstash to be autostart services
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable logstash.service

## Start Logstash
systemctl start logstash.service
