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
    exit 1
  fi
}