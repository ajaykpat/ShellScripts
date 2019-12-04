#! /bin/sh

cd /home/crvmas/Backup/ML02_CMS/ && ls -t | tail +8 | xargs rm --
cd /home/crvmas/Backup/ML02_CRDL/ && ls -t | tail +8 | xargs rm --
cd /home/crvmas/Backup/ML02_MRF/ && ls -t | tail +8 | xargs rm --
cd /home/crvmas/Backup/ML02_CASSANDRA/ && ls -t | tail +8 | xargs rm --