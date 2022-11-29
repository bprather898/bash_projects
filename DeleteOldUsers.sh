#!/bin/bash
 
# DeleteOldUsers.sh
#
# Description: Script will pull the list of home directories based on how long its been since they've been
# interacted with. If it has been greater than 30 days, the account will be deleted, except
# for the whitelisted admin accounts. 
#
# Author: Bryson Prather
# Date Modified: 11/17/22

 
keep1="/Users/Admin"
 
keep2="/Users/Remote"
 
keep3="/Users/Auburn"
 

 
USERLIST=`find /Users -type d -maxdepth 1 -mindepth 1 -not -name "." -atime +30`

for name in $USERLIST ; do
 
 [[ "$name" == "$keep1" ]] && continue #skip account 1
 
 [[ "$name" == "$keep2" ]] && continue #skip account 2
 
 [[ "$name" == "$keep3" ]] && continue #skip account 3
 
 echo "Deleting account and home directory for" $name
 
 dscl . delete $name #delete the account
 
 rm -r $name #delete the home directory
 
done