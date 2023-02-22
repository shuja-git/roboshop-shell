code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}
echo -e "\e[1;35m Installing Nginx\e[0m"
yum install nginx -y &>>${log_file}
echo -e "\e[1;35m Removing Old Contents\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[1;35m Downloading frontend\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
echo -e "\e[1;35m Extracting frontend\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}
echo -e "\e[1;35m Copying into roboshop conf\e[0m"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[1;35m Enabling Nginx\e[0m"
systemctl enable nginx &>>${log_file}
echo -e "\e[1;35m Starting Nginx\e[0m"
systemctl restart nginx &>>${log_file}


#if any command is failed or errored then we need to stop the script
