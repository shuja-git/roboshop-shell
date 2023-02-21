echo "\e[35mInstalling Nginx\e[0m"
yum install nginx -y
echo "\e[35;1mRemoving Old Contents\e[0m"
rm -rf /usr/share/nginx/html/*
echo "\e[35mDownloading frontend\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
echo "\e[35mExtracting frontend\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
echo "\e[35mCopying into roboshop conf\e[0m"
cp configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
echo "\e[35mEnabling Nginx\e[0m"
systemctl enable nginx
echo "\e[35mStarting Nginx\e[0m"
systemctl restart nginx


#if any command is failed or errored then we need to stop the script
