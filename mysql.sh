source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
    echo -e "\e[31mMissing mysql password argument\e[0m"
fi

print_head "Disable mysql 8"
dnf module disable mysql -y
status_check $?

print_head "Install mysql 5.7"
yum install mysql-community-server -y
status_check $?

print_head "Enable mysql"
systemctl enable mysqld
status_check $?

print_head "start mysql"
systemctl start mysqld
status_check $?

print_head "Set mysql default password "
mysql_secure_installation --set-root-pass ${mysql_root_password}
status_check $?
#RoboShop@1


