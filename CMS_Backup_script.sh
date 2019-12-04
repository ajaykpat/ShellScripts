#!/bin/bash
a=`date +%Y%m%d%H%M%S`
[ ! -d /data/CMS ] && mkdir -p /data/CMS 
mkdir /data/CMS/$a
mkdir /data/CMS/$a/DB
mkdir /data/CMS/$a/CONFD
mysqldump -ucontrolDb -pmavenir --add-drop-database --routines --all-databases | gzip > /data/CMS/$a/DB/Full_Dump_CMS_DB.$a.sql.gz
cp /opt/dist/confd_schema/cms.fxs /data/CMS/$a/CONFD/bkp.$a.cms.fxs
cp /opt/dist/confd_schema/cms.yang /data/CMS/$a/CONFD/bkp.$a.cms.yang
chown -R admin:admin /data/CMS/$a/CONFD/bkp.$a.cms.fxs
chown -R admin:admin /data/CMS/$a/CONFD/bkp.$a.cms.yang
cp -rp /data/redun/yang /data/CMS/$a/
tar -czf /data/CMS/$a.tar /data/CMS/$a --remove-files
find /data/CMS/ -type f -and \( -size 0 -or -mtime +7 \) -exec rm {} \;
