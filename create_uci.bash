#!/bin/bash
# edit for your needs

# do not edit below
configs=(alfred batmanadv dhcp dropbear firewall network system vnstat wireless)
parameters=./ffcp_parameter.conf
configpath=./files/etc/config
alfredfile=$configpath/alfred
batmanadvfile=$configpath/batman\-adv
dhcpfile=$configpath/dhcp
dropbearfile=$configpath/dropbear
dropbearkeyfiles=./files/etc/dropbear/authorized_keys
firewallfile=$configpath/firewall
networkfile=$configpath/network
systemfile=$configpath/system
vnstatfile=$configpath/vnstat
wirelessfile=$configpath/wireless
modulesdir=ffcp_modules.d
privmodulesdir=ffcp_private_modules.d
devicesdir=ffcp_devices.d
privdevicesdir=ffcp_private_devices.d
function initfile {
	# $1 is file to check given as relative path
	if [ -f $1 ]; then
		> $1
	else
		touch $1
	fi
}
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
		source $parameters
	else
		source $privdevicesdir/$1
		source $parameters
	fi
	# initialize config files
	for fileelement in $alfredfile $batmanadvfile $dhcpfile $dropbearfile $firewallfile $networkfile $systemfile $vnstatfile $wirelessfile $dropbearkeyfiles; do
		initfile $fileelement
	done
	# loop over elements
	for alfredelement in "${alfred[@]}"; do
		catelement $modulesdir $alfredelement >> $alfredfile
	done
	for batmanadvelement in "${batmanadv[@]}"; do
		catelement $modulesdir $batmanadvelement >> $batmanadvfile
	done
	for dhcpelement in "${dhcp[@]}"; do
		catelement $modulesdir $dhcpelement >> $dhcpfile
	done
	for dropbearelement in "${dropbear[@]}"; do
		catelement $modulesdir $dropbearelement >> $dropbearfile
	done
	for firewallelement in "${firewall[@]}"; do
		catelement $modulesdir $firewallelement >> $firewallfile
	done
	for networkelement in "${network[@]}"; do
		catelement $modulesdir $networkelement >> $networkfile
	done
	for systemelement in "${system[@]}"; do
		catelement $modulesdir $systemelement >> $systemfile
	done
	for vnstatelement in "${vnstat[@]}"; do
		catelement $modulesdir $vnstatelement >> $vnstatfile
	done
	for wirelesselement in "${wireless[@]}"; do
		catelement $modulesdir $wirelesselement >> $wirelessfile
	done
	for key in "${sshpubkeys[@]}"; do
		echo $key >> $dropbearkeyfiles
	done
fi
