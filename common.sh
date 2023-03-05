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
schema_setup(){
  if [ "${schema_type}" == "mongo" ]; then
        print_head "Copy mongodb repo file"
        cp ${code_dir}/configs/mongo.repo /etc/yum.repos.d/mongo.repo
        status_check $?
        print_head "Installing mongo client"
        yum install mongodb-org-shell -y &>>"${log_file}"
        status_check $?
        print_head "Load Schema"
        mongo --host mongodb-dev.shujadevops.online </app/schema/${component}.js &>>${log_file}
        status_check $?
  elif [ "${schema_type}" == "mysql" ]; then
       print_head "Install mysql client"
       yum install mysql -y &>>"${log_file}"
       status_check $?
       print_head "Load schema"
       mysql -h mysql-dev.shujadevops.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>"${log_file}"
       status_check $?
  fi

}
app_prereq_setup(){
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
}
systemd_setup(){
   print_head "Copy systemd Service file"
    cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
    status_check $?

    sed -i -e "s/ROBOSHOP_USER_PASSWORD/${roboshop_app_password}/" /etc/systemd/system/${component}.service &>>${log_file}
    echo ${roboshop_app_password}
    print_head "Reload SystemD"
    systemctl daemon-reload &>>${log_file}
    status_check $?
    print_head "Enable ${component} service "
    systemctl enable ${component} &>>${log_file}
    status_check $?
    print_head "Restart ${component} service"
    systemctl restart ${component} &>>${log_file}
    status_check $?

}
python(){
  print_head "Install python"
  yum install python36 gcc python3-devel -y &>>${log_file}
  status_check $?

  app_prereq_setup

  print_head "Download Dependencies"
  pip3.6 install -r requirements.txt &>>${log_file}
  status_check $?

  systemd_setup
}

Nodejs(){
  print_head "Configure Nodejs Repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
  status_check $?
  print_head "Install Nodejs"
  yum install nodejs -y &>>${log_file}
  status_check $?

  app_prereq_setup

  print_head "Installing Nodejs dependencies"
  npm install &>>${log_file}
  status_check $?


  schema_setup
  systemd_setup

}

java(){
  print_head "Install Maven"
  yum install maven -y &>>${log_file}
  status_check $?

  app_prereq_setup

  print_head "Download dependencies & package"
  mvn clean package &>>${log_file}
  mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
   status_check $?

# schema setup function
  schema_setup

 #Systemd function
 systemd_setup

}

go(){
  print_head "Install golang"
  yum install golang -y &>>${log_file}
  status_check $?

  app_prereq_setup

  print_head "Download Dependencies"
  go mod init dispatch &>>${log_file}
  go get &>>${log_file}
  go build &>>${log_file}
  status_check $?

  systemd_setup

}