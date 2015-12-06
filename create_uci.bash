#!/bin/bash
# edit for your needs

# do not edit below
scriptpath=files/etc/uci-defaults/79_create_uci 
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
function grabarrayelement {
	declare -a argAry1=("${!1}")
	for $(echo $1element) in "${argAry1[@]}"; do
		catelement "$modulesdir" "$1"element >> "$1"file
	done
}
function listdevices {
	echo -e "\tdevices:"
	ls $devicesdir
	echo -e "\tprivate devices:"
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
	echo "Please choose one of the available configs by giving its name as a parameter!"
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

if [ $notindevicesdir -eq $notinprivdevicesdir ] ; then
	# config is either not available or in both directories
	echo "The given config is wrong. It's either in none or in both folders. Please choose one of the available configs!"
	listdevices
	exit ${argAry1[@]}
else
	# config is ok to use
	# here's action beginning
	if [ $notindevicesdir -eq 0 ]; then
		source $devicesdir/$1
		echo "$devicesdir/$1 sourced"
	else
		source $privdevicesdir/$1
		echo "$privdevicesdir/$1 sourced"
	fi
	source $parameters
	# initialize config files
	for fileelement in $alfredfile $batmanadvfile $dhcpfile $dropbearfile $firewallfile $networkfile $systemfile $vnstatfile $wirelessfile $dropbearkeyfiles; do
		initfile $fileelement
	done
	# loop over elements
	# not working, yet
	# grabarrayelement alfred
	for alfredelement in "${alfred[@]}"; do
		catelement $modulesdir $alfredelement >> $alfredfile
	done
	echo "alfred done"
	for batmanadvelement in "${batmanadv[@]}"; do
		catelement $modulesdir $batmanadvelement >> $batmanadvfile
	done
	echo "batmanadv done"
	for dhcpelement in "${dhcp[@]}"; do
		catelement $modulesdir $dhcpelement >> $dhcpfile
	done
	echo "dhcp done"
	for dropbearelement in "${dropbear[@]}"; do
		catelement $modulesdir $dropbearelement >> $dropbearfile
	done
	echo "dropbear done"
	for firewallelement in "${firewall[@]}"; do
		catelement $modulesdir $firewallelement >> $firewallfile
	done
	echo "firewall done"
	for networkelement in "${network[@]}"; do
		catelement $modulesdir $networkelement >> $networkfile
	done
	echo "network done"
	for systemelement in "${system[@]}"; do
		catelement $modulesdir $systemelement >> $systemfile
	done
	echo "system done"
	for vnstatelement in "${vnstat[@]}"; do
		catelement $modulesdir $vnstatelement >> $vnstatfile
	done
	echo "vnstat done"
	for wirelesselement in "${wireless[@]}"; do
		catelement $modulesdir $wirelesselement >> $wirelessfile
	done
	echo "wireless done"

	for key in "${sshpubkeys[@]}"; do
		echo $key >> $dropbearkeyfiles
	done
	echo "sshkeys done"
	#echo "#!/bin/ash" > $scriptpath
	## 5 ghz set channel
	#echo "uci set wireless.radio0.channel='$channel5'" >> $scriptpath
	## 24 ghz set channel
	#echo "uci set wireless.radio1.channel='$channel24'" >> $scriptpath
	#echo "uci commit" >> $scriptpath
	#echo "exit 0" >> $scriptpath
	echo "all done"
fi
