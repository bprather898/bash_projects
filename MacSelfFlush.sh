#!/bin/bash

# Title: Mac Self Flush 
#
# "Insert funny quote here when you can." - Me 
# 
# Description: This is a bash script meant to run on Macbooks, via policy in Jamf to flush all of its own failed/pending commands.
#
# Author: Bryson Prather
# Date Modified: 10/5/22

echo "Flushing Pending and Failed commands on self..."

################################################
# Edit This section with relevant information. #
################################################
# Please put the URL of your Jamf Portal (https://jss.XXXXX.org:XXXX)
URL=""
API_USER=""
API_PASS=""

######################################################
# 1. Have the Macbook get its own indentifying info. #
######################################################

# We will be using the MAC addr since that is static and reliable. 
MACADDRESS=$(networksetup -getmacaddress en0 | awk '{ print $3 }')

#####################
# 2. Hit the flush. #
#####################

echo "Flushing all pending commands..."
curl -sfku "$API_USER":"$API_PASS" "$URL"/JSSResource/commandflush/computers/macaddress/"$MACADDRESS"/status/Pending -X DELETE
echo "Flushing all failed commands..."
curl -sfku "$API_USER":"$API_PASS" "$URL"/JSSResource/commandflush/computers/macaddress/"$MACADDRESS"/status/Failed -X DELETE

echo "All commands should be flushed from this device... Thank you..."