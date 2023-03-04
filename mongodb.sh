source common.sh

print_head "Setup mongodb repos"
cp configs/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?
print_head "Install Mongodb"
yum install mongodb-org -y &>>${log_file}
status_check $?
#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}
print_head "Enable mongodb"
systemctl enable mongod &>>${log_file}
status_check $?
print_head "Start mongodb"
systemctl restart mongod  &>>${log_file}
status_check $?


