code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}
print_head(){
echo -e "\e[1;36m$1 \e[0m"
}

print_head "Install Nginx"
yum install nginx -y &>>${log_file}
print_head "Removing Old Contents"
rm -rf /usr/share/nginx/html/*
print_head "Downloading frontend"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
print_head "Extracting frontend"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}
print_head "Copying into roboshop conf"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
print_head "Enabling Nginx"
systemctl enable nginx &>>${log_file}
print_head "Starting Nginx"
systemctl restart nginx &>>${log_file}


#if any command is failed or errored then we need to stop the script
