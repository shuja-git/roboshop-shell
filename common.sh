code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}
print_head(){
echo -e "\e[1;36m$1 \e[0m"
}

status_check(){
  if [ $1 -eq 0 ]; then
      echo -e "\e[33mSuccess\e[0m"
  else
    echo -e "\e[33mFailure\e[0m"
    echo -e "\e[31msee file ${log_file} for more information on error"
    exit 1
  fi
}

Nodejs(){
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
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
  status_check $?
  cd /app

  print_head "Extracting app contents"
  unzip /tmp/${component}.zip &>>${log_file}
  status_check $?
  print_head "Installing Nodejs dependencies"
  npm install &>>${log_file}
  status_check $?
  print_head "Copy systemd Service file"
  cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
  status_check $?
  print_head "Reload SystemD"
  systemctl daemon-reload &>>${log_file}
  status_check $?
  print_head "Enable ${component} service "
  systemctl enable ${component} &>>${log_file}
  status_check $?
  print_head "Restart ${component} service"
  systemctl restart ${component} &>>${log_file}
  status_check $?
  print_head "Copy mongodb repo file"
  cp ${code_dir}/configs/mongo.repo /etc/yum.repos.d/mongo.repo
  status_check $?
  print_head "Installing mongo client"
  yum install mongodb-org-shell -y &>>"${log_file}"
  status_check $?
  print_head "Load Schema"
  mongo --host mongodb-dev.shujadevops.online </app/schema/${component}.js &>>${log_file}
  status_check $?

}