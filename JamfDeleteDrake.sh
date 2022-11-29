#!/bin/bash

# JamfDeleteDrake.sh
# This script will look through jamf and delete all classes with "J F Drake Middle School" in their name. 
# I am did not get a lot of sleep last night, so no big pramble. Lets just get on with it. 

#####################
# 1. Get user info. #
#####################
server="XXXXXXX"
read -p "Jamf Pro Username: " API_USER
read -s -p "Jamf Pro Password: " API_PASS
echo ""

echo "Deleting all classes at J.F. Drake now!"
echo ""
#####################################################
# 2. Grab the classes ID list and run a loop on it. #
#####################################################
# This line pulls down all classes in jamf and passes back a list containing all their IDs
classID=$(curl -ksu "$API_USER":"$API_PASS" -H "accept: text/xml" "$server"/JSSResource/classes | xmllint --format - | awk -F '[<>]' '/id/{print $3}')

# Read out loud, this line means "For every class passed our classID list, do X things"
for class in $classID;do

	####################################
	# 3. Grab the specific class name. #
	####################################
	# This line will pull down the current classes' name value so that we can operate based on it. 
	className=`curl -su $API_USER:$API_PASS -X GET "$server/JSSResource/classes/id/$class" -H "accept: text/xml" | xmllint --xpath "class/name/text()" -`

	######################################
	# 4. If its from Drake, gun it down. #
	######################################
	# The echo is just to tell us what we're looking at. Incase something goes wrong it'll tell us the class that f'd up. 
	echo "Found Class, $className"
	#The actual statement that evaluates name to determine if it contains "J F Drake Middle School" then delete or nah.
	if [[ $className == *"J F Drake Middle School"* ]] ; then
    	echo "Class is at J F Drake Middle School, deleting ..."
    	curl -ksu "$API_USER":"$API_PASS" -H "Content-type: text/xml" "$server"/JSSResource/classes/id/"$class" -X DELETE
	else 
		echo "Not at J F Drake Middle School, skipping..."
	fi
	echo ""
done