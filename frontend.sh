
source common.sh

print_head "Install Nginx"
yum install nginx -y &>>${log_file}
echo $?
print_head "Removing Old Contents"
rm -rf /usr/share/nginx/html/*
echo $?
print_head "Downloading frontend"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
echo $?
print_head "Extracting frontend"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}
echo $?
print_head "Copying into roboshop conf"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
echo $?
print_head "Enabling Nginx"
systemctl enable nginx &>>${log_file}
echo $?
print_head "Starting Nginx"
systemctl restart nginx &>>${log_file}
echo $?


#if any command is failed or errored then we need to stop the script
