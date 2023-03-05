source common.sh


roboshop_user_password=$1
if [ -z "${roboshop_user_password}" ]; then
    echo -e "\e[31mMissing Roboshop User password argument\e[0m"
    exit 1
fi

component=payment
python
#--------------------------------------------------
