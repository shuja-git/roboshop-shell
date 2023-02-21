echo -e "\e[1;35m Installing Nginx\e[0m"
yum install nginx -y
echo -e "\e[1;35m Removing Old Contents\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[1;35m Downloading frontend\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
echo -e"\e[1;35m Extracting frontend\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
echo -e "\e[1;35m Copying into roboshop conf\e[0m"
pwd
ls -l
cp configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[1;35m Enabling Nginx\e[0m"
systemctl enable nginx
echo -e "\e[1;35m Starting Nginx\e[0m"
systemctl restart nginx


#if any command is failed or errored then we need to stop the script
