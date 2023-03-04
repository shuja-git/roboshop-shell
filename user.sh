source common.sh

print_head "Configure Nodejs Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?
print_head "Install Nodejs"
yum install nodejs -y &>>${log_file}
status_check $?
print_head "Create Roboshop user"
id roboshop &>>${log_file}
if [ "$?" -ne 0 ]; then
useradd roboshop
fi
status_check $?
print_head "Create application directory"
if [ ! -d /app ]; then
mkdir /app
fi
status_check $?
print_head "Delete Old contents"
rm -rf /app/* &>>${log_file}
status_check $?
print_head "Downloading app contents"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log_file}
status_check $?
cd /app

print_head "Extracting app contents"
unzip /tmp/user.zip &>>${log_file}
status_check $?
print_head "Installing Nodejs dependencies"
npm install &>>${log_file}
status_check $?
print_head "Copy systemd Service file"
cp ${code_dir}/configs/user.service /etc/systemd/system/user.service
status_check $?
print_head "Reload SystemD"
systemctl daemon-reload &>>${log_file}
status_check $?
print_head "Enable user service "
systemctl enable user &>>${log_file}
status_check $?
print_head "Restart user service"
systemctl restart user &>>${log_file}
status_check $?
print_head "Copy mongodb repo file"
cp ${code_dir}/configs/mongo.repo /etc/yum.repos.d/mongo.repo
status_check $?
print_head "Installing mongo client"
yum install mongodb-org-shell -y &>>"${log_file}"
status_check $?
print_head "Load Schema"
mongo --host mongodb-dev.shujadevops.online </app/schema/user.js &>>${log_file}
status_check $?