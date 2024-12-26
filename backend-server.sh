#!/bin/bash

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER
 
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $? -ne 0 ]
  then
    echo -e "$R Please use the root access $N" | tee -a $LOG_FILE
exit 1 
fi

echo "Script started executing at: $(date)" | tee -a $LOG_FILE

VALIDATE() {
    if [ $1 -ne 0 ]
       then
         echo -e "$2 is $R not success $N" | tee -a $LOG_FILE
        
     else
       echo -e "$2 is $G success $N" | tee -a $LOG_FILE
   fi

   
}

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "Disable default nodejs"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "Enable nodejs:20"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "Install nodejs"

id expense &>>$LOG_FILE
if [ $? -ne 0 ]
then
    echo -e "expense user not exists... $G Creating $N"
    useradd expense &>>$LOG_FILE
    VALIDATE $? "Creating expense user"
else
    echo -e "expense user already exists...$Y SKIPPING $N"
fi
mkdir -p /app

VALIDATE $? "Creating /app folder"
curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE
VALIDATE $? "Downloading backend application code"

cd /app
rm -rf /app/* # remove the existing code
unzip /tmp/backend.zip &>>$LOG_FILE
VALIDATE $? "Extracting backend application code"

npm install &>>$LOG_FILE

 cp /home/ec2-user/Expense-shell/backend.service /etc/systemd/system/backend.service

# load the data before running backend

# nf install mysql -y &>>$LOG_FILE
# VALIDATE $? "Installing MySQL Client"

# mysql -h mysql.rajashekar-devops.online -u root -pExpenseApp@1 -e < /app/schema/backend.sql &>>$LOG_FILE
# VALIDATE $? "Schema loading"

# systemctl daemon-reload &>>$LOG_FILE
# VALIDATE $? "Daemon reload"

# systemctl enable backend &>>$LOG_FILE
# VALIDATE $? "Enabled backend"

# systemctl restart backend &>>$LOG_FILE
# VALIDATE $? "Restarted Backend"

        
