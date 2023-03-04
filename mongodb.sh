source common.sh

print_head "Setup mongodb repos"
cp configs/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
if [ "$?" -eq 0 ]; then
    echo success
fi
print_head "Install Mongodb" &>>${log_file}
yum install mongodb-org -y &>>${log_file}
echo $?
print_head "Enable mongodb"
systemctl enable mongod &>>${log_file}
echo $?
print_head "Start mongodb"
systemctl start mongod  &>>${log_file}
echo $?
#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
