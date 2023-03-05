source common.sh

roboshop_app_password=$1
if [ -z "${roboshop_app_password}" ]; then
  echo -e "\e[31mRabbitMQ App User password is missing\e[0m"
  exit 1
fi
print_head "setup Earlang Repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh |  bash &>>"${log_file}"
status_check $?
print_head "set up Rabbitmq Repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>"${log_file}"
status_check $?
print_head "install Rabbit and Earlang"
yum install rabbitmq-server erlang -y &>>"${log_file}"
status_check $?

print_head "Enable Rabbitmq Service"
systemctl enable rabbitmq-server &>>"${log_file}"
status_check $?
print_head "Start Rabbitmq service"
systemctl start rabbitmq-server &>>"${log_file}"
status_check $?
print_head "Add Application User"
rabbitmqctl list_users | grep roboshop
if [ $? -ne 0 ]; then
 rabbitmqctl add_user roboshop ${roboshop_app_password} &>>"${log_file}"
fi
status_check $?

print_head "Configure permissions for app user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>"${log_file}"
status_check $?