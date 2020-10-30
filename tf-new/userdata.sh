#!/bin/bash

yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on

echo "Hello World!" >> /var/www/html/index.html
