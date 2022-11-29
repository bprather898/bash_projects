#!/bin/bash


# Title: mac Auto Rename
#
# Description: This is a bash script to gather 1. The asset tag information and 2, The building location for a macbook, then set its name accordingly
#              on both jamf and locally. 
#
# Sources: 
# 
#   1. Many parts were taken and modified from this forum post: 
#      https://community.jamf.com/t5/jamf-pro/renaming-computers-using-asset-tag-data-api/m-p/30798
#
# Author: Bryson Prather
# Date Modified: 5/12/22

#########################################
# 1. Get all of our variables from JSS. #
#########################################
MACADDRESS=$(networksetup -getmacaddress en0 | awk '{ print $3 }')
JSS=XXXX
#Input valid user/pass that can make requests and upload info to jamf server. 
API_USER=XXXX 
API_PASS=XXXX
ASSET_TAG_INFO=$(curl -k $JSS/JSSResource/computers/macaddress/$MACADDRESS --user $API_USER:$API_PASS | xmllint --xpath '/computer/general/asset_tag/text()' -)
BUILDING=$(curl -k $JSS/JSSResource/computers/macaddress/$MACADDRESS --user $API_USER:$API_PASS | xmllint --xpath '/computer/location/building/text()' -)
PREFIX=""

# These Lines are for testing purposes
#echo "Fetching location..."
#echo "Location is $BUILDING"

#################################
# 2. Assign prefix by building. #
#################################

# Find the appropriate building, and assign prefix by building.
if [ "$BUILDING" == "Central Office" ]; then
 PREFIX="CO-"
# One to One Schools
elif [ "$BUILDING" == "Auburn High School" ]; then
 PREFIX="AHS-"
elif [ "$BUILDING" == "Auburn Junior High School" ]; then
 PREFIX="AJHS-"
elif [ "$BUILDING" == "East Samford School" ]; then
 PREFIX="ESS-"
elif [ "$BUILDING" == "Drake Middle School" ]; then
 PREFIX="DMS-"

# WMR & DRES
elif [ "$BUILDING" == "Wrights Mill Road Elementary School" ]; then
 PREFIX="WMR-"
elif [ "$BUILDING" == "Dean Road Elementary School" ]; then
 PREFIX="DRES-"

# AEEC & OES
elif [ "$BUILDING" == "Auburn Early Education Center" ]; then
 PREFIX="AEEC-"
elif [ "$BUILDING" == "Ogletree Elementary School" ]; then
 PREFIX="OES-"

# PES & CWES
elif [ "$BUILDING" == "Pick Elementary School" ]; then
 PREFIX="PES-"
elif [ "$BUILDING" == "Cary Woods Elementary School" ]; then
 PREFIX="CWES-"

# CES & RES
elif [ "$BUILDING" == "Creekside Elementary School" ]; then
 PREFIX="CES-"
elif [ "$BUILDING" == "Richland Elementary School" ]; then
 PREFIX="RES-"

# YES & WPES
elif [ "$BUILDING" == "Yarbrough Elementary School" ]; then
 PREFIX="YES-"
elif [ "$BUILDING" == "Woodland Pines Elementary School" ]; then
 PREFIX="WPES-"
# ^ This one qualifies as preparing for the future ^ (Circa 2022)
fi

###################
# 3. Assign name. #
###################

if [ -n "$ASSET_TAG_INFO" ]; then
 echo "Processing new name for this client..."
 echo "Changing name..."
 scutil --set HostName $PREFIX"$ASSET_TAG_INFO"
 scutil --set ComputerName $PREFIX"$ASSET_TAG_INFO$"
 curl -u $API_USER:$API_PASS -X PUT "$JSS/JSSResource/computers/macaddress/$MACADDRESS" -H "content-type: text/xml" -d "<computer><general><display_name>$PREFIX"$ASSET_TAG_INFO"</display_name><device_name>$PREFIX"$ASSET_TAG_INFO"</device_name><name>$PREFIX"$ASSET_TAG_INFO"</name></general></computer>"
 echo "Name change complete. ($PREFIX"$ASSET_TAG_INFO")"

else
echo "Asset Tag information was unavailable. Unable to update name."

fi