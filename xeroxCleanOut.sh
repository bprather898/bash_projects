#!/bin/bash

# Title: Xerox Clean Out  
#
# Description: This script will find and remove all files related to Xerox on mac. 
#
# Sources: 
#
#	1. This script follows along with this Xerox article just to automate it. 
#		https://www.support.xerox.com/en-us/article/en/jk1LuQD8si3kQT2EQGy4U9
#
# Author: Bryson Prather
# Date Modified: 3/29/22

##########
# NOTES: #
##########
# Please note that this script ends with a reboot command call, don't get scared by it. Please. 
# Someone already was scared of it. 

echo "*** Beginning Xerox Clean Out ***";
echo "This may take a few moments, and will be followed by a reboot...";


##############################
# 1. Kill all Applications.  #
##############################

#For this I'm trying to kill all processes related to "Xerox" "xerox" and "print"

sudo killall "*Xerox*";
sudo killall "*xerox*";
sudo killall "*print*";

#################################
# 2. Remove Xerox Applications. #
#################################

#Literally if it has "Xerox" or "xerox" in the Applications/... folder, remove it.
sudo mv /Applications/Xerox* .Trash/;

#####################################################
# 3. Remove Xerox from various "Library" Locations. #
#####################################################

echo "Deleting the following:"
# 3.1, Library/Applications Support/
sudo rm -rfv /Library/Application\ Support/Xerox;


# 3.2, Library/ColorSync/Profiles/ 
# Note: Delete all "Xerox" "xerox" and "XRX" files/folders.
sudo find /Library/ColorSync/Profiles/ -name "XRX*" -delete -print;
sudo find /Library/ColorSync/Profiles/ -name "*Xerox*" -delete -print;
sudo find /Library/ColorSync/Profiles/ -name "*xerox*" -delete -print;
sudo rm -rfv /Library/ColorSync/Profiles/Xerox;


# 3.3, Library/Image Capture/TWAIN Data Sources/
# Note: We're here for the Xerox Printer Packages...
sudo find /Library/Image\ Capture/TWAIN\ Data\ Sources/ -name "*Xerox*" -delete -print;
sudo find /Library/Image\ Capture/TWAIN\ Data\ Sources/ -name "*xerox*" -delete -print;


# 3.4, Library/Printers/...
# Note: It is important here we also remove the printer data saved on here too.
sudo find /Library/Printers/ -name "*Xerox*" -delete -print;
sudo find /Library/Printers/ -name "*xerox*" -delete -print;
sudo rm -rfv /Library/Printers/Xerox;


# 3.5, Library/Printers/PPDs/Contents/Resources/...
sudo find /Library/Printers/PPDs/Contents/Resources/ -name "*Xerox*" -delete -print;
sudo find /Library/Printers/PPDs/Contents/Resources/ -name "*xerox*" -delete -print;
sudo rm -rfv /Library/Printers/PPDs/Contents/Resources/Xerox;


# 3.6, Library/Receipts/...
# Note: We're deleting all with the following: 
# 1. Files beginning and ending with pde****.pkg, and xpd****.pkg
# 2. Files begging with ICC* and ICP*
# 3. The ICC_Profiles folder. 
sudo find /Library/Receipts/ -name "pde*.pkg" -delete -print;
sudo find /Library/Receipts/ -name "xpd*.pkg" -delete -print;
sudo find /Library/Receipts/ -name "ICC*" -delete -print;
sudo find /Library/Receipts/ -name "ICP*" -delete -print;


# 3.7, Library/Receipts/SSScan/
sudo find /Library/Receipts/SSScan/ -name "*Xerox*" -delete -print;
sudo find /Library/Receipts/SSScan/ -name "*xerox*" -delete -print;
sudo rm -rfv /Library/Receipts/SSScan/Xerox;


# 3.8, Library/Preferences/...
# Note: We're deleting all files 
# 1. Beginning with com.xerox.***
# 2. Files beginning with com.apple.print.custompresets.forprinter.(yourXeroxPrinterName).plist
# For point 2, probably any presets with the word "Xerox" or "xerox" in it. 
sudo find /Library/Preferences/ -name "com.xerox.*" -delete -print;
sudo find /Library/Preferences/ -name "com.apple.print.custompresets.forprinter.*.plist" -delete -print;


# 3.9, Library/Caches/... cmon man.
# Note: Delete all files beginning with XRXSetup.***
sudo find /Library/Caches/ -name "XRXSetup*" -delete -print;



# 3.10, remove anything in /var/db/receipts/
# Note: anything with com.xerox.* is dead. 
sudo find /var/db/receipts/ -name "com.xerox.*" -delete -print;


#######################################
# 4. Finally, empty trash and reboot. # 
#######################################
sudo rm -rfv .Trash/Xerox*;

echo "Xerox files have been removed fully... Rebooting...";
sudo shutdown -r now;

