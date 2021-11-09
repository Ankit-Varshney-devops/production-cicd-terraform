#!/bin/bash
sudo apt-get update
sudo apt install build-essential -y
sudo apt-get install nginx -y
sudo apt-get install net-tools
sudo curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install nodejs -y
sudo npm install pm2@latest -g
sudo pm2 install pm2-logrotate
sudo apt-get install postgresql-client -y
PGPASSWORD=${master_pass} psql -h ${host} -U postgres -c "create user ${user} with password '${pass}';"
PGPASSWORD=${master_pass} psql -h ${host} -U postgres -c "create database ${db_name}"
PGPASSWORD=${master_pass} psql -h ${host} -U postgres -c "grant all privileges on database ${db_name} to ${user}"
sudo apt-get install ruby -y 
wget https://aws-codedeploy-${region}.s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto > /tmp/logfile 
sudo ./install auto -v releases/codedeploy-agent-###.deb > /tmp/logfile
sudo service codedeploy-agent status