source common.sh

print_head "Setup mongodb repos" &>>${log_file}
cp configs/mongo.repo /etc/yum.repos.d/mongo.repo
echo $?
print_head "Install Mongodb" &>>${log_file}
yum install mongodb-org -y
echo $?
print_head "Enable mongodb" &>>${log_file}
systemctl enable mongod
echo $?
print_head "Start mongodb" &>>${log_file}
systemctl start mongod
echo $?
#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
