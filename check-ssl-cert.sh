#!/bin/bash
# Script to check SSL expiration
# Author: juliomauro@gmail.com
# Date: 17-05-2015
# Last modification: 03-06-2018

# CHECK $1 VARIABLE
if [ -z "$1" ] ;
then
 echo "Usage check-ssl-cert.sh [SITE]"
 echo ""
 echo "      Example: check-ssl-cert.sh www.cisco.com"
 exit 1
fi

# VARIABLES

SITE=$1; 
EMAIL="infra@tr3nd0per4d0r4.com.br";
DAYS=7;
ONEDAY="86400"
EXPIRATIONDATE=$(date -d "$(: | openssl s_client -connect $SITE:443 -servername $SITE 2>/dev/null \
                              | openssl x509 -text \
                              | grep 'Not After' \
                              |awk '{print $4,$5,$7}')" '+%s'); 
IN7DAYS=$(($(date +%s) + (86400*$DAYS)));
resultunix=$(($EXPIRATIONDATE - $(date +%s)));
resulthuman=`echo $((resultunix / ONEDAY))`

# SCRIPT

if [ $IN7DAYS -gt $EXPIRATIONDATE ]; then
    echo "KO - Certificate for $SITE expires in less than $DAYS days, on $(date -d @$EXPIRATIONDATE '+%Y-%m-%d')" \
    | echo "Certificate expiration warning for $SITE" $EMAIL ;
else
    echo "OK - Certificate expires on $resulthuman days" ;
fi;
