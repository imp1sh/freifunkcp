#!/bin/bash
# edit for your needs

# do not edit below
configs=(alfred batmanadv dhcp dropbear firewall network system vnstat wireless)
configpath=./files/etc/config
modulesdir=ffcp_modules.d
privmodulesdir=ffcp_private_modules.d
devicesdir=ffcp_devices.d
privdevicesdir=ffcp_private_devices.d
function catelement {
	if [ -f $1/$2 ]; then
		cat $1/$2
	else
		cat $privmodulesdir/$2
	fi
}
function listdevices {
	echo "devices:"
	ls $devicesdir
	echo "private devices:"
	ls $privdevicesdir
}
function isuseable {
	# $1 is file $2 is folder1 $3 is folder2
	# returns 0 if file is ok to use
	# returns 1 is file is in none of the two folders
	# returns 2 is file is in both folders i.e. conflict
	if [ `ls $2|grep -c $1` -eq 0 ]; then
		foundinone=1
	else
		foundinone=0
	fi
	if [ `ls $3|grep -c $1` -eq 0 ]; then
		foundintwo=1
	else
		foundintwo=0
	fi
	if [ $((foundinone + $foundintwo)) -eq 2 ]; then
		return 2
	elif [ $((foundinone + $foundintwo)) -eq 1 ]; then
		return 0
	else
		return 1
	fi
}

if [ -z "$1" ]; then
	echo "Please choose one of the available configs!"
	listdevices
	exit 1
fi
if [ `ls $devicesdir|grep -c $1` -eq 0 ]; then
	notindevicesdir=1
else
	notindevicesdir=0
fi
if [ `ls $privdevicesdir | grep -c $1` -eq 0 ]; then
	notinprivdevicesdir=1
else
	notinprivdevicesdir=0
fi

if [ $notindevicesdir -eq $notinprivdevicesdir ]; then
	# config is either not available or in both directories
	echo "The given config is wrong. It's either in none or in both folders. Please choose one of the available configs!"
	listdevices
	exit 2
else
	# config is ok to use
	if [ $notindevicesdir -eq 0 ]; then
		source $devicesdir/$1
	else
		source $privdevicesdir/$1
	fi
	# loop over elements
	for alfredelement in "${alfred[@]}"; do
		catelement $modulesdir $alfredelement >> $configpath/alfred
	done
	for batmanadvelement in "${batmanadv[@]}"; do
		catelement $modulesdir $batmanadvelement >> $configpath/batman\-adv
	done
	for dhcpelement in "${dhcp[@]}"; do
		catelement $modulesdir $dhcpelement >> $configpath/dhcp
	done
	for dropbearelement in "${dropbear[@]}"; do
		catelement $modulesdir $dropbearelement >> $configpath/dropbear
	done
	for firewallelement in "${firewall[@]}"; do
		catelement $modulesdir $firewallelement >> $configpath/firewall
	done
	for networkelement in "${network[@]}"; do
		catelement $modulesdir $networkelement >> $configpath/network
	done
	for systemelement in "${system[@]}"; do
		catelement $modulesdir $systemelement >> $configpath/system
	done
	for vnstatelement in "${vnstat[@]}"; do
		catelement $modulesdir $vnstatelement >> $configpath/vnstat
	done
	for wirelesselement in "${wireless[@]}"; do
		catelement $modulesdir $wirelesselement >> $configpath/wireless
	done
fi
