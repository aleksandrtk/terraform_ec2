#!/bin/bash
yum -y update
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
yum -y install httpd
echo "hello!" > /var/www/html/index.html
service httpd start
chkconfig httpd on