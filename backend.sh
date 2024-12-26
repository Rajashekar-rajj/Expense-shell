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

VALIDATE() {
    if [ $1 -ne 0 ]
       then
         echo -e "$2 is $R not success $N" | tee -a $LOG_FILE
        
     else
       echo -e "$2 is $G success $N" | tee -a $LOG_FILE
   fi
}

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "Installing nodejs success"
        

        
