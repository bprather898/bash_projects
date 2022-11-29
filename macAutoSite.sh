#!/bin/bash


# Title: mac Auto Site
#
# Description: This is a bash script to gather the building information of the macbook, and then set the site accordingly. 
#
# Sources: 
# 
#   1. Many parts were taken and modified from this forum post: 
#      https://community.jamf.com/t5/jamf-pro/renaming-computers-using-asset-tag-data-api/m-p/30798
#
# Author: Bryson Prather
# Date Created: 7/15/22


##############
# EDIT HERE. #
##############

#Input jamf portal. (i.e. jss.schoolschool.org:port)
JSS=XXXX
#Input valid user/pass that can make requests and upload info to jamf server. 
API_USER=XXXX 
API_PASS=XXXX

##################################
#								 #
# DO NOT EDIT BEYOND THIS POINT. #
#								 #
##################################

#########################################
# 1. Get all of our variables from JSS. #
#########################################
MACADDRESS=$(networksetup -getmacaddress en0 | awk '{ print $3 }')
BUILDING=$(curl -k $JSS/JSSResource/computers/macaddress/$MACADDRESS --user $API_USER:$API_PASS | xmllint --xpath '/computer/location/building/text()' -)

# These Lines are for testing purposes
#echo "Fetching location..."
#echo "Location is $BUILDING"

###############################
# 2. Assign site by building. #
###############################

# Find the appropriate building, and assign SITE by building.
if [ "$BUILDING" == "" ]; then
	echo "Building not found... Unable to site Macbook..."
else
	echo "Assigning site: $BUILDING"

	if [ "$BUILDING" == "Central Office" ]; then
	 ID="6"
	# One to One Schools
	elif [ "$BUILDING" == "Auburn High School" ]; then
	 ID="3"
	elif [ "$BUILDING" == "Auburn Junior High School" ]; then
	 ID="4"
	elif [ "$BUILDING" == "East Samford School" ]; then
	 ID="14"
	elif [ "$BUILDING" == "Drake Middle School" ]; then
	 ID="8"

	# WMR & DRES
	elif [ "$BUILDING" == "Wrights Mill Road Elementary School" ]; then
	 ID="12"
	elif [ "$BUILDING" == "Dean Road Elementary School" ]; then
	 ID="7"

	# AEEC & OES
	elif [ "$BUILDING" == "Auburn Early Education Center" ]; then
	 ID="2"
	elif [ "$BUILDING" == "Ogletree Elementary School" ]; then
	 ID="9"

	# PES & CWES
	elif [ "$BUILDING" == "Pick Elementary School" ]; then
	 ID="10"
	elif [ "$BUILDING" == "Cary Woods Elementary School" ]; then
	 ID="5"

	# CES & RES
	elif [ "$BUILDING" == "Creekside Elementary School" ]; then
	 ID="15"
	elif [ "$BUILDING" == "Richland Elementary School" ]; then
	 ID="11"

	# YES & WPES
	elif [ "$BUILDING" == "Yarbrough Elementary School" ]; then
	 ID="13"
	elif [ "$BUILDING" == "Woodland Pines Elementary School" ]; then
	 ID="16"
	# ^ This one qualifies as preparing for the future ^ (Circa 2022)
	fi

	echo "Assigning site ID: $ID"
	#Now we take the site id and in combination with the buuilding info and put it in Jamf. 
	curl -u $API_USER:$API_PASS -X PUT "$JSS/JSSResource/computers/macaddress/$MACADDRESS" -H "content-type: text/xml" -d "<computer><general><site><id>$ID</id><name>$BUILDING</name></site></general></computer>"
fi