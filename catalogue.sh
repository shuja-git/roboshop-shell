source common.sh

print_head "Configure Nodejs Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
echo $?
print_head "Install Nodejs"
yum install nodejs -y &>>${log_file}
echo $?
print_head "Create Roboshop user"
useradd roboshop
echo $?
print_head "Create application directory"
mkdir /app
echo $?
print_head "Delete Old contents"
rm -rf /app/* &>>${log_file}
echo $?
print_head "Downloading app contents"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
echo $?
cd /app

print_head "Extracting app contents"
unzip /tmp/catalogue.zip &>>${log_file}
echo $?
print_head "Installing Nodejs dependencies"
npm install &>>${log_file}
echo $?
print_head "Copy systemd Service file"
cp configs/catalogue.service /etc/systemd/system/catalogue.service
echo $?
print_head "Reload SystemD"
systemctl daemon-reload &>>${log_file}
echo $?
print_head "Enable cataloge service "
systemctl enable catalogue &>>${log_file}
echo $?
print_head "Restart Catalogue service"
systemctl restart catalogue &>>${log_file}
echo $?
print_head "Copy mongodb repo file"
cp configs/mongo.repo /etc/yum.repos.d/mongo.repo
echo $?
print_head "Installing mongo client"
yum install mongodb-org-shell -y &>>${log_file}
echo $?
print_head "Load Schema"
mongo --host mongodb.shujadevops.online </app/schema/catalogue.js &>>${log_file}
echo $?