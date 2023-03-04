source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
    echo -e "\e[31mMissing mysql password argument\e[0m"
    exit 1
fi

print_head "Disable mysql 8"
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "copy mysql repo file"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}

print_head "Install mysql 5.7"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "Enable mysql"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "start mysql"
systemctl start mysqld &>>${log_file}
status_check $?

print_head "Set root password "
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
status_check $?
#RoboShop@1


