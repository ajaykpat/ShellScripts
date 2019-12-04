#! /bin/sh
#set -xv  

##########################################
## This Script copy backup on remote    ##
## backup server.                       ##
## Author: Ajaykumar Patel              ##
## Date: 2019-11-21                     ##
##########################################


USERNAME=crvmas
HOSTS="172.21.100.38"

LogDir="/home/crvmas/Backup/Logs"
CMS_BACKUP="/home/crvmas/Backup/ML02_CMS/"
CRDL_BACKUP="/home/crvmas/Backup/ML02_CRDL/"
CASSANDRA_BACKUP="/home/crvmas/Backup/ML02_CASSANDRA/"
MRF_BACKUP="/home/crvmas/Backup/ML02_MRF/"


unset -f backupLogFile;
backupLogFile() {
  mkdir -p ${LogDir}
  Logfile=${LogDir}/BackUp.log

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
logBackup "Starting transfer of backup to Backup server."

####################  CMS BACKUP ###################
unset -f cmsBackup;

cmsBackup()
{

for i in `find $CMS_BACKUP -type f -ctime -1`
do
        scp $i ${USERNAME}@${HOSTS}:/nbupool/crvmas/ML02_CMS/

if [ $? -eq 0 ]; then
        logBackup "CMS backup transferred successfully."
else
        logBackup "ERROR : CMS backup transferr Failed."
fi;

done

}
logBackup "Transffering CMS backup."
cmsBackup
####################  CRDL BACKUP ###################

unset -f crdlBackup;

crdlBackup()
{

for i in `find $CRDL_BACKUP -type f -ctime -1`
do
        scp $i ${USERNAME}@${HOSTS}:/nbupool/crvmas/ML02_CRDL/

if [ $? -eq 0 ]; then
        logBackup "CRDL backup transferred successfully."
else
        logBackup "ERROR : CRDL backup transferr Failed."
fi;

done

}
logBackup "Transffering CRDL backup."

crdlBackup

####################  CASSANDRA BACKUP ###################

unset -f cassandraBackup;

cassandraBackup()
{

for i in `find $CASSANDRA_BACKUP -type f -ctime -1`
do
        scp $i ${USERNAME}@${HOSTS}:/nbupool/crvmas/ML02_CASSANDRA/

if [ $? -eq 0 ]; then
        logBackup "CASSANDRA backup transferred successfully."
else
        logBackup "ERROR : CASSANDRA backup transferr Failed."
fi;

done

}
logBackup "Transffering CASSANDRA backup."

cassandraBackup

####################  MRF BACKUP ###################

## TAR the folder in Backup directory#####

logBackup " TAR the MRF backup in backup directory."

unset -f mrftar;
mrftar()
{
a=`date +%Y%m%d%H%M%S`
tar_folder=`ls -lrth $MRF_BACKUP | grep -v total | grep -v "tar.gz" | awk '{print $9}'`
cd $MRF_BACKUP; tar -czf $a.tar.gz /home/crvmas/Backup/Temp;
if [ $? -eq 0 ]; then
        logBackup "MRF backup TAR successfully."
else
        logBackup "ERROR : MRF backup tar Failed."
fi;

}
mrftar

unset -f mrfbackup;

mrfBackup()
{

for i in `find $MRF_BACKUP -type f -ctime -1`
do
        scp $i ${USERNAME}@${HOSTS}:/nbupool/crvmas/ML02_MRF/

if [ $? -eq 0 ]; then
        logBackup "MRF backup transferred successfully."
else
        logBackup "ERROR : MRF backup transferr Failed."
fi;

done

}

logBackup "Transffering MRF backup."

mrfBackup

logBackup "*****************Backup of all node successfully completed.******************"

