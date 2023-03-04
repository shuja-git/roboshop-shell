source common.sh

print_head "Setup mongodb repos" &>>${log_file}
cp configs/mongo.repo /etc/yum.repos.d/mongo.repo
if [ "$?" -q 0 ]; then
    echo -e "\e[33m Success\e[0m"
fi
print_head "Install Mongodb" &>>${log_file}
yum install mongodb-org -y
if [ $? -q 0 ]; then
    echo -e "\e[33m Success\e[0m"
fi

print_head "Enable mongodb" &>>${log_file}
systemctl enable mongod
if [ $? -q 0 ]; then
    echo -e "\e[33m Success\e[0m"
fi

print_head "Start mongodb" &>>${log_file}
systemctl start mongod
if [ $? -q 0 ]; then
    echo -e "\e[33m Success\e[0m"
fi

#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
