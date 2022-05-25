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

## Perform a full system update
yum update -y

## Install Base Elastic Search Components
amazon-linux-extras install java-openjdk11 -y

## Add the Elastic Search Repository
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

cat >> /etc/yum.repos.d/elasticsearch.repo <<-EOF
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

# cat > /etc/logstash/conf.d/windows-eventlogs.conf <<-EOF
# input {
#   kinesis {
#     kinesis_stream_name => "${NAMESPACE}_windows_eventlogs"
#     codec => cloudwatch_logs
#     tags => ["windows_eventlogs"]
#   }
# }
# filter {
#     if "windows_eventlogs" in [tags] {
#         xml {
#             source => "message"
#             target => "parsed"
#             remove_field => "message"
#         }
#     }
# }
# output {
#     if "windows_eventlogs" in [tags] {
#         elasticsearch {
#             index => "windows-eventlogs"
#         }
#     }
# }
# EOF

cat > /etc/logstash/conf.d/cloudwatch-metrics.conf <<-EOF
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
