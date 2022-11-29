#!/bin/zsh

# Title: One Drive Rename
#
# Description: Hunts down every instance of the "OneDrive - Auburn City Schools" and modifies every file name there in
#              replacing every illegal character with the legal '_' character. 
#
# Sources: 
# 
#   1. Instances of this code were taken from a source on Jamf Nation (I think) but I forgot the link. Apologies.
#
# Author: Bryson Prather
# Date Modified: 5/13/22

##########
# NOTES: #
##########
# This script must be ran as administrator, or with administrator permissions, but as current user. 
# So, that means you must be logged in at the target user, and su Admin to properly run this. 
# (Unless they're an admin on their machine, then its all good probs.)
# Additonally, its important to know this directory searches every main directory on the user folder. I highlight and call them
# out in the comments down below, but for quick reading its: 
# /User/* 
# /Applications/* ;  /Desktop/* ; /Documents/* ; /Downloads/* ; /Movies/* ; /Music/* ; /Pictures/*

##########################################
# 1. Fetch our currently logged in user. #
##########################################
loggedInUser=$( ls -l /dev/console | awk '{print $3}' )
    if [[ -z "$loggedInUser" ]] || [[  "$loggedInUser" == 'root' ]] || [[ "$loggedInUser" == "loginwindow" ]] ; then
        loggedInUser="$3"
    fi

autoload zmv
echo "Searching for OneDrive Folder..."

# Original versoin of oneDriveFolder variable vvv
#oneDriveFolder=/Users/$loggedInUser/OneDrive\ -\ Auburn\ City\ Schools

#oneDriveFolder=`sudo find /Users/$loggedInUser/* -name "OneDrive - Auburn City Schools"  -type d  2> /dev/null`

##########################
# 2. Search and correct. #
##########################

# Well. Theres a use case issue, since it is possible for users to have multiple one drive folders after remapping it without thinking. 
# My solution? Get explicit.
# These are search commands branching from every generic user directory and one last one hardcoded into user directory. This is every
# **EXPLICITLY POSSIBLE** One Drive Folder location. If there exists any deeper (nested one drives on desktop for example) well then that
# person is just trying to be difficult now aren't they? Anywho, our rifle's loaded lets go hunting some files.

    # In Applications
    oneDriveApps=`sudo find /Users/$loggedInUser/Applications/* -name "OneDrive - Auburn City Schools"  -type d  2> /dev/null`
    if [[ -d ${oneDriveApps} ]] ; then
        cd "${oneDriveApps}"
        pwd
        echo "One drive folder found in /Users/$loggedInUser/Applications/ ...Correcting..."
        echo ""
        zmv '(**/)(*)' '$1${2//[^A-Za-z0-9. ]/_}'
        zmv '(**/)(*)' '$1${${2##[[:space:]]#}%%[[:space:]]#}'
    else
        echo "OneDrive Folder not Found in /Users/$loggedInUser/Applications/... moving on."
        echo ""    
    fi


    # In Desktop
    oneDriveDesk=`sudo find /Users/$loggedInUser/Desktop/* -name "OneDrive - Auburn City Schools"  -type d  2> /dev/null`
    if [[ -d ${oneDriveDesk} ]] ; then
        cd "${oneDriveDesk}"
        pwd
        echo "One drive folder found in /Users/$loggedInUser/Desktop/ ...Correcting..."
        echo ""
        zmv '(**/)(*)' '$1${2//[^A-Za-z0-9. ]/_}'
        zmv '(**/)(*)' '$1${${2##[[:space:]]#}%%[[:space:]]#}'
    else
        echo "OneDrive Folder not Found in /Users/$loggedInUser/Desktop/... moving on."
        echo ""    
    fi

    # In Documents
    oneDriveDocs=`sudo find /Users/$loggedInUser/Documents/* -name "OneDrive - Auburn City Schools"  -type d  2> /dev/null`
    if [[ -d ${oneDriveDocs} ]] ; then
        cd "${oneDriveDocs}"
        pwd
        echo "One drive folder found in /Users/$loggedInUser/Documents/ ...Correcting..."
        echo ""
        zmv '(**/)(*)' '$1${2//[^A-Za-z0-9. ]/_}'
        zmv '(**/)(*)' '$1${${2##[[:space:]]#}%%[[:space:]]#}'
    else
        echo "OneDrive Folder not Found in /Users/$loggedInUser/Documents/... moving on."
        echo ""
    fi

    # In Downloads for some reason?
    oneDriveDown=`sudo find /Users/$loggedInUser/Downloads/* -name "OneDrive - Auburn City Schools"  -type d  2> /dev/null`
    if [[ -d ${oneDriveDown} ]] ; then
        cd "${oneDriveDown}"
        pwd
        echo "One drive folder found in /Users/$loggedInUser/Downloads/ ...Correcting... "
        echo ""
        zmv '(**/)(*)' '$1${2//[^A-Za-z0-9. ]/_}'
        zmv '(**/)(*)' '$1${${2##[[:space:]]#}%%[[:space:]]#}'
    else
        echo "OneDrive Folder not Found in /Users/$loggedInUser/Downloads/... moving on."
        echo ""
    fi

    # It better not be here in Movies...
    oneDriveMovie=`sudo find /Users/$loggedInUser/Movies/* -name "OneDrive - Auburn City Schools"  -type d  2> /dev/null`
    if [[ -d ${oneDriveMovie} ]] ; then
        cd "${oneDriveMovie}"
        pwd
        echo "One drive folder found in /Users/$loggedInUser/Movies/ ...Correcting..."
        echo ""
        zmv '(**/)(*)' '$1${2//[^A-Za-z0-9. ]/_}'
        zmv '(**/)(*)' '$1${${2##[[:space:]]#}%%[[:space:]]#}'
    else
        echo "OneDrive Folder not Found in /Users/$loggedInUser/Movies/... moving on."
        echo ""
    fi

    # Or here in Music...
    oneDriveMusic=`sudo find /Users/$loggedInUser/Music/* -name "OneDrive - Auburn City Schools"  -type d  2> /dev/null`
    if [[ -d ${oneDriveMusic} ]] ; then
        cd "${oneDriveMusic}"
        pwd
        echo "One drive folder found in /Users/$loggedInUser/Music/ ...Correcting..."
        echo ""
        zmv '(**/)(*)' '$1${2//[^A-Za-z0-9. ]/_}'
        zmv '(**/)(*)' '$1${${2##[[:space:]]#}%%[[:space:]]#}'
    else
        echo "OneDrive Folder not Found in /Users/$loggedInUser/Music/... moving on."
        echo ""
    fi

    # and certainly not in Pictures...
    oneDrivePics=`sudo find /Users/$loggedInUser/Pictures/* -name "OneDrive - Auburn City Schools"  -type d  2> /dev/null`
    if [[ -d ${oneDrivePics} ]] ; then
        cd "${oneDrivePics}"
        pwd
        echo "One drive folder found in /Users/$loggedInUser/Pictures/ ...Correcting..."
        echo ""
        zmv '(**/)(*)' '$1${2//[^A-Za-z0-9. ]/_}'
        zmv '(**/)(*)' '$1${${2##[[:space:]]#}%%[[:space:]]#}'
    else
        echo "OneDrive Folder not Found in /Users/$loggedInUser/Pictures/... moving on."
        echo ""
    fi

    # In /Users/Username
    oneDriveFolder=/Users/$loggedInUser/OneDrive\ -\ Auburn\ City\ Schools
    if [[ -d ${oneDriveFolder} ]] ; then
        cd "${oneDriveFolder}"
        pwd
        echo "One drive folder found in /Users/$loggedInUser ...Correcting..."
        echo ""
        zmv '(**/)(*)' '$1${2//[^A-Za-z0-9. ]/_}'
        zmv '(**/)(*)' '$1${${2##[[:space:]]#}%%[[:space:]]#}'
    else
        echo "OneDrive Folder not Found in /Users/$loggedInUser... moving on."
        echo ""    
    fi    

    echo "All target directories have been searched... Exiting program."

exit 0