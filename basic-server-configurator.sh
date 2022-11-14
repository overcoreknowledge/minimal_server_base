#!bin/bash

ROOT_DIR=/root

WEB_SERVICE_NAME=httpd
WEB_SERVICE_DEFAULT_FW=http
WEB_SERVICE_SSL=https
WEB_CONF_DIR=/etc/httpd/conf
WEB_CONF_FILE=/etc/httpd/conf/httpd.conf
WEB_CONF_FILE_BACKUP=/etc/httpd/conf/httpd.conf-backup

FTP_SERVICE_NAME=vsftpd
FTP_DATA_PORT=20
FTP_TRANSFER_PORT=21
FTP_PROTOCOL_PORT_T=tcp
FTP_PROTOCOL_PORT_U=udp
FTP_CONF_DIR=/etc/vsftpd
FTP_CONF_FILE=/etc/vsftpd/vsftpd.conf
FTP_CONF_FILE_BACKUP=/etc/vsftpd/vsftpd.conf-backup

WEB_BASE_USER=webapps
WEB_BASE_PASSWD=webapps

WEB_CONF_FILE_GITHUB_URL=https://github.com/overcoreknowledge/minimal_server_base/raw/main/httpd.conf
FTP_CONF_FILE_GITHUB_URL=https://github.com/overcoreknowledge/minimal_server_base/raw/main/vsftpd.conf

SPEEDTEST_GITHUB_URL=https://github.com/overcoreknowledge/minimal_server_base/raw/main/speedtest.py
SPEEDTEST_FILENAME=speedtest.py

#CHECKING & UPDATING SYSTEM PACKAGES
yum update -y
yum upgrade -y
#DELETE FTP & WEB PACKAGES
yum remove -y $FTP_SERVICE_NAME
yum remove -y $WEB_SERVICE_NAME
#DELETE INTERNET-SPEED-TESTER
rm -f $SPEEDTEST_FILENAME
#DELETE FTP & WEB PACKAGES
yum install -y $FTP_SERVICE
yum install -y $WEB_SERVICE
#MAKING BACKUP FOR ORIGINAL CONFIGURATION FILES
scp $WEB_CONF_FILE $WEB_CONF_FILE_BACKUP
scp $FTP_CONF_FILE $FTP_CONF_FILE_BACKUP
#DELETING FTP & WEB CONF FILES
rm -f $WEB_CONF_FILE
rm -f $FTP_CONF_FILE
#CHANGING TO WEB CONF DIRECTORY
cd $WEB_CONF_DIR
#DOWNLOADING CUSTOM CONF-FILE FOR OUR WEB PACKAGE
wget -O $WEB_CONF_FILE_GITHUB_URL
#CHANGING TO FTP CONF DIRECTORY
cd $FTP_CONF_DIR
#DOWNLOADING CUSTOM CONF-FILE FOR OUR FTP PACKAGE
wget -O $FTP_CONF_FILE_GITHUB_URL
#CREATE CHROOT FILE FOR JAIL (FTP-USERS)
echo " " >> chroot.list
#CHANGING TO ROOT DIRECTORY
cd $ROOT_DIR
#DOWNLOADING INTERNET-SPEED-TESTER
wget -O $SPEEDTEST_GITHUB_URL
#MAKING SPEED-TESTER EXECUTABLE
chmod +x $SPEEDTEST_FILENAME
#FIREWALL.D RULES FOR WEB SERVICE
firewalld-cmd --zone-permanent=public --add-service=$WEB_SERVICE_DEFAULT_FW
firewalld-cmd --zone-permanent=public --add-service=$WEB_SERVICE_SSL
#FIREWALL.D RULES FOR FTP SERVICE
firewalld-cmd --zone-permanent=public --add-port=$FTP_DATA_PORT/$FTP_PROTOCOL_PORT_T
firewalld-cmd --zone-permanent=public --add-port=$FTP_TRANSFER_PORT/$FTP_PROTOCOL_PORT_T
firewalld-cmd --zone-permanent=public --add-port=$FTP_DATA_PORT/$FTP_PROTOCOL_PORT_U
firewalld-cmd --zone-permanent=public --add-port=$FTP_TRANSFER_PORT/$FTP_PROTOCOL_PORT_U
#SAVING & RELOADING FIREWALL.D ADDED RULES
firewall-cmd --reload
#MAKING USER FOR FTP SERVICE
useradd $WEB_BASE_USER
#########################################################################################
echo " "
echo "Recuerde asignar password al usuario: "$WEB_BASE_USER
echo " " 
echo "       Remember set user password to: "$WEB_BASE_USER
