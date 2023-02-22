source common.sh

print_head "Setup mongodb repos"
cp configs/mongo.repo /etc/yum.repos.d/mongo.repo

print_head "Install Mongodb"
yum install mongodb-org -y

print_head "Enable mongodb"
systemctl enable mongod

print_head "Start mongodb"
systemctl start mongod

#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
