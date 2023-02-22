code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}
print_head(){
echo -e "\e[1;36m$1 \e[0m"
}

print_head "Setup mongodb repos"
cp configs/mongo.repo /etc/yum.repos.d/mongo.repo

print_head "Install Mongodb"
yum install mongodb-org -y

print_head "Enable mongodb"
systemctl enable mongod

print_head "Start mongodb"
systemctl start mongod

#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
