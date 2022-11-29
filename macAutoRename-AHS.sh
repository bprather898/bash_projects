#!/bin/bash


# Title: mac Auto Rename AHS
#
# Description: This is a bash script to gather 1. The asset tag information and 2. The building location for a macbook, then set its name accordingly
#              on both jamf and locally. 
#
# Sources: 
# 
#   1. Many parts were taken and modified from this forum post: 
#      https://community.jamf.com/t5/jamf-pro/renaming-computers-using-asset-tag-data-api/m-p/30798
#

#########################################
# 1. Get all of our variables from JSS. #
#########################################
MACADDRESS=$(networksetup -getmacaddress en0 | awk '{ print $3 }')
JSS=XXXX
#Input valid user/pass that can make requests and upload info to jamf server. 
API_USER=XXXX 
API_PASS=XXXX
REAL_NAME=$(curl -k $JSS/JSSResource/computers/macaddress/$MACADDRESS --user $API_USER:$API_PASS | xmllint --xpath '/computer/general/asset_tag/text()' -)
PREFIX="MBA-"


#################################
# 2. Assign prefix by building. #
#################################

#This version is only for AHS, therefore prefix was hardcoded above, and this step will passed over here. 

###################
# 3. Assign name. #
###################

if [ -n "$REAL_NAME" ]; then
 echo "Processing new name for this client..."
 echo "Changing name..."
 scutil --set HostName $PREFIX"$REAL_NAME"
 scutil --set ComputerName $PREFIX"$REAL_NAME"
 curl -u $API_USER:$API_PASS -X PUT "$JSS/JSSResource/computers/macaddress/$MACADDRESS" -H "content-type: text/xml" -d "<computer><general><display_name>$PREFIX"$REAL_NAME"</display_name><device_name>$PREFIX"$REAL_NAME"</device_name><name>$PREFIX"$REAL_NAME"</name></general></computer>"
 echo "Name change complete. ($PREFIX"$REAL_NAME")"

else
echo "User name information was unavailable. Unable to update name."

fi