#!/bin/bash

# Title: networkCleanup.sh
#
# Description: This is a bash script to parse through saved networks on a Mac and eliminate ones we do not want.
#
# Sources: 
# 
#   1. Many parts were taken and modified from this jamf forum post: 
#      https://community.jamf.com/t5/jamf-pro/remove-wireless-network-ssid/m-p/137084
#
# Author: Bryson Prather
# Date Modified: 8/8/22

##########
# Notes: #
##########

# Approved networks are as follows: 
# acs-teach
# ACS-Staff
# ACS-3D
# ACS-Enrollment

# Unapproved networks are as follows:
# ACS-Guest
#
#

SSIDS=$(networksetup -listpreferredwirelessnetworks "en0" | sed '1d')
CURRENTSSID=$(networksetup -getairportnetwork "en0" | sed 's/^Current Wi-Fi Network: //')

while read -r SSID; do
  if [ "$SSID" == "acs-teach" ]; then
    echo Skipping network $SSID
  elif [ "$SSID" == "ACS-Guest" ]; then
    echo Deleteing network $SSID
    networksetup -removepreferredwirelessnetwork "en0" "$SSID"
  else
    echo Skipping network $SSID
  fi
done <<< "$SSIDS"

echo "All networks have been evaluated, Thank you..."