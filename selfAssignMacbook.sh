#!/bin/zsh


# Title: selfAssignMacBook 
#
# Description: This script will determine who is the current user of the Macbook, and will assign that name as their Username in Jamf. 
#
# Author: Bryson Prather
# Date Modified: 6/13/22

##########
# NOTES: #
##########

#####################################
# 				Edit here...		#
#####################################
# Please put the URL of your Jamf Portal (https://jss.XXXXX.org:XXXX)
JSS=XXXXXX

API_USER=XXXXXX
API_PASS=XXXXXX

#####################################
#	DO NOT EDIT PAST THIS POINT.	#
#####################################

#####################################################################
# 1. Fetch our currently logged in user and mac address of macbook. #
#####################################################################

# Fetches logged in user
loggedInUser=$( ls -l /dev/console | awk '{print $3}' )
    if [[ -z "$loggedInUser" ]] || [[  "$loggedInUser" == 'root' ]] || [[ "$loggedInUser" == "loginwindow" ]] ; then
        loggedInUser="$3"
    fi

# Fetches Mac Address of Macbook
MACADDRESS=$(networksetup -getmacaddress en0 | awk '{ print $3 }')


#############################################
# 2. Assign logged in user name to macbook. #
#############################################

curl -u $API_USER:$API_PASS -X PUT "$JSS/JSSResource/computers/macaddress/$MACADDRESS" -H "content-type: text/xml" -d "<computer><location><username>$loggedInUser</username></location></computer>"
