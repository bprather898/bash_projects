#!/bin/sh

# Title: nameChange_v2
#
# Description: This script is designed to simplify and streamline the process that macbooks must
#				under-go when a teacher's last name is changed. 
#
# Author(s): Bryson Prather, Patrick King
# Date Modified: 7/22/22

##########
# NOTES: #
##########
# This is bouta be some sorta dark magic bullshit up in here... Because this is complicated as messeroni. 
# ***IMPORTANT*** This script needs to be ran from the admin user profile with the target user fully logged out. 

################################
# 1. Get info from abt target. #
################################

# First lets ask who our target user is. 
echo $"*****************************************************************************
* Welcome to Name Change Assistant...										
* Please Read the following Carefully. 										
* 																			
* 1. If you are not logged in as 'admin' then end this script with 			
* ctrl+c and log out then back into admin.								
*																			
* 2. Please make sure the target user is fully logged out, and is not still.
* alive in the background.													
*****************************************************************************"
read -p 'Old Username: ' oldUser

# Next get the info for the new user profile. 

read -p 'New Username: ' newUser
read -p 'New Real Name (Example Wayne, Bruce): ' realName

#####################################################
# 2. Confirm correct credentials and final warning. #
#####################################################

# Statement to Catch if they misspell the user or user folder just not present... 
if [ ! -d "/Users/$oldUser" ]; then
	echo "***Error: Specified user or user home directory not found... Please try again..."
	exit 0
fi

# Let's grab the old user RealName while we're at it.  
oldRealName=$(echo $(sudo dscl . read /Users/$oldUser/ RealName) | awk '{ print substr($0, 11 ) }')

echo $"
Target User Located...

Username: $oldUser
Realname: $oldRealName

Will be converted to:

Username: $newUser
Realname: $realName

"
read -p 'Please confirm [y/n]: ' nothin

if [ "$nothin" = "n" ]; then
	echo "Quitting Name Change Assistant..."
	exit 0
fi

####################################################
# 3. Determine if target has admin, if so, remove. #
####################################################

adpriv=$(echo $(dseditgroup -o checkmember -m $oldUser admin) | cut -c1-3)

if [ "$adpriv" = "yes" ]; then
    echo "Target User Profile has Admin Permissions...
    "
   	echo "Attempting removal of Admin Permissions from Target User $oldUser..."
   	sudo dseditgroup -o edit -d $oldUser -t user admin
   	echo "Attempt finished, please restart machine, then confirm admin
   	permissions have been removed, and run this script again. Thank you..."
    exit 0
fi

######################################################
# 4. Re-assign Realname, Account Name, and Home dir. #
######################################################

# 4.1 Reassign Realname.
sudo dscl . change /Users/$oldUser RealName "$oldRealName" "$realName"
# 4.2 Reassign Account Name.
sudo dscl . change /Users/$oldUser RecordName "$oldUser" "$newUser"
# 4.3 Reassign Home Directory. 
sudo dscl . change /Users/$newUser NFSHomeDirectory /Users/$oldUser /Users/$newUser

#########################################################################
# 5. Make sure target has ownership of their homedir and it's contents. #
#########################################################################
# Move old dir to new dir
sudo chmod -R 777 /Users/$oldUser
sudo mv /Users/$oldUser /Users/$newUser
sudo chown -Rv $newUser /Users/$newUser
sudo chmod -R 755 $newUser /Users/$newUser

echo "**********************************************
* Name Change Process complete...			 
* Please restart this computer... Thank you. 
**********************************************"

## Last minute Silent check for admin priv, since it seems like something in this is giving them it during all this. 
adpriv=$(echo $(dseditgroup -o checkmember -m $newUser admin) | cut -c1-3)
if [ "$adpriv" = "yes" ]; then
   	sudo dseditgroup -o edit -d $newUser -t user admin
    exit 0
fi
