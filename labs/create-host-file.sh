#!/bin/bash

# Description: This script creates the host file which is needed by ansible play book.
# @Author: Aseem Jain

# pull up the ip address of host
HOST_IP=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')

# pull up credentials from secret manager
USER_ID=$(aws secretsmanager get-secret-value --secret-id hanosql --version-stage AWSCURRENT --region us-east-1 | jq --raw-output '.SecretString' | jq -r .mongodb_userid)
PASS=$(aws secretsmanager get-secret-value --secret-id hanosql --version-stage AWSCURRENT --region us-east-1 | jq --raw-output '.SecretString' | jq -r .db_password)

echo "Retrieved user is as $USER_ID and passwrod as $PASS" >> $SCRIPT_LOG
# Query all secondary
SECONDARY=$(mongo --host $HOST_IP --quiet --username=$USER_ID --password=$PASS --authenticationDatabase=admin --eval "db.runCommand('ismaster').hosts")

# Query primary
PRIMARY=$(mongo --host $HOST_IP --quiet --username=$USER_ID --password=$PASS --authenticationDatabase=admin --eval "printjson(rs.status().members.filter(function(m) { return m.state ===1 })[0].name)")

echo "$clustername has primary node as $PRIMARY" >> $SCRIPT_LOG

# clean up ips and append in host file
sudo echo $SECONDARY | sed "s/$PRIMARY//" | sed 's/^.//; s/.$//; s/:27017//g; s/"//g;' | sed "s/,/\n/g"  >> $HOST_FILE
sudo echo $PRIMARY | sed 's/:27017//; s/"//g' >> $HOST_FILE

# remove empty line and blank chars from host file
sudo sed '/^[[:space:]]*$/d' -i $HOST_FILE
sudo sed "s/^[ \t]*//" -i $HOST_FILE

echo "Finished creating the hosts file for ansible" >> $SCRIPT_LOG
cat $HOST_FILE