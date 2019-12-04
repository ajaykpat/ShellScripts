#! /bin/sh
#set -xv  

##########################################
## This Script to find backup on remote ##
## server and copy them file server     ##
## Author: Ajaykumar Patel              ##
## Date: 2019-11-21                     ##
##########################################


USERNAME=root
CRDL_HOST="10.215.71.113"
CMS_HOST="10.215.70.132"
CASSANDRA_HOST="10.215.71.114"

LogDir="/home/crvmas/Backup/Logs"
CMS_BACKUP="/home/crvmas/Backup/ML02_CMS/"
CRDL_BACKUP="/home/crvmas/Backup/ML02_CRDL/"
CASSANDRA_BACKUP="/home/crvmas/Backup/ML02_CASSANDRA/"
MRF_BACKUP="/home/crvmas/Backup/ML02_MRF/"


unset -f backupLogFile;
backupLogFile() {
  mkdir -p ${LogDir}
  Logfile=${LogDir}/BackUp_PULL.log

  if [ -f "$Logfile" ]; then
      cat $Logfile >> $Logfile.old
  fi
  touch $Logfile
}
backupLogFile
unset -f logBackup;
logBackup()
{
  TP="+%H:%M:%S"
  TS=`date $TP|sed 's/ /0/g'`
  [ ! -z "$Logfile" ] && \
    echo "$TS: $1" >> $Logfile
    echo "$TS: $1"
}
logBackup "*********Starting Pull of backup to file server.*****************"


unset -f crdlpull;

crdlpull()
{
ssh $USERNAME@$CRDL_HOST "find /data/CRDL_OldFullBackup -type f -ctime -1" > /tmp/crdl_list.txt
while read filename; do
        scp $USERNAME@$CRDL_HOST:$filename $CRDL_BACKUP
done < /tmp/crdl_list.txt

if [ $? -eq 0 ]; then
        logBackup "CRDL backup Pulled successfully."
else
        logBackup "ERROR : CRDL backup Pull Failed."
fi;

}

logBackup "*********Starting pull of CRDL backup to file server.*****************"

crdlpull

unset -f cmspull;

cmspull()
{
ssh $USERNAME@$CMS_HOST "find /data/CMS/ -type f -ctime -1" > /tmp/cms_list.txt
while read filename; do
        scp $USERNAME@$CMS_HOST:$filename $CMS_BACKUP
done < /tmp/cms_list.txt

if [ $? -eq 0 ]; then
        logBackup "CMS backup Pulled successfully."
else
        logBackup "ERROR : CMS backup Pull Failed."
fi;

}

logBackup "*********Starting pull of CMS backup to file server.*****************"
cmspull

cassandrapull()
{

ssh root@$CASSANDRA_HOST tar czf - /usr/local/dse-5.0.14/resources/cassandra/conf/ > $CASSANDRA_BACKUP/$(date +%Y%m%d%H%M%S).tar.gz

if [ $? -eq 0 ]; then
        logBackup "CASSANDRA backup Pulled successfully."
else
        logBackup "ERROR : CASSANDRA backup Pull Failed."
fi;


}

logBackup "*********Starting pull of CASSANDRA backup to file server.*****************"

cassandrapull
