#!/bin/bash
# edit for your needs

# do not edit below
ucidefaultspath=files/etc/uci-defaults
# instead maybe source from ./doc/configs
configs=(alfred batmanadv dhcp dropbear firewall network system vnstat wireless)
parameterfile="$1"
configpath=./files/etc/config
sshpubkeyfile=sshpubkeys
uciparameterfile="ffcp_parameter.conf"
ucienvfile="ffcp_env.conf"

alfredfile="$configpath/alfred"
batmanadvfile="$configpath/batman-adv"
dhcpfile="$configpath/dhcp"
dropbearfile="$configpath/dropbear"
dropbearkeyfiles="./files/etc/dropbear/authorized_keys"
firewallfile="$configpath/firewall"
networkfile="$configpath/network"
systemfile="$configpath/system"
vnstatfile="$configpath/vnstat"
wirelessfile="$configpath/wireless"

modulesdir="ffcp_modules.d"
privmodulesdir="ffcp_private_modules.d"
devicesdir="ffcp_devices.d"
privdevicesdir="ffcp_private_devices.d"
parametersdir="ffcp_parameters.d"
privparametersdir="ffcp_private_parameters.d"
envdir="ffcp_env.d"
privenvdir="ffcp_private_env.d"

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
function listparameters {
	echo -e "\tparameters:"
	ls $parametersdir/*.conf | awk -F'/' '{print $NF}'
	echo -e "\tprivate parameters:"
	ls $privparametersdir/*.conf | awk -F'/' '{print $NF}'
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

# check if first parameter is given
if [ -z "$1" ]; then
	echo "Error. Please choose one of the available configs by giving its name as a parameter!"
	listparameters
	exit 1
fi
# check if chosen parameter is a private one or a regular one
if [ `ls $parametersdir|grep -c $parameterfile` -eq 0 ]; then
	notinparametersdir=1
else
	notinparametersdir=0
fi
if [ `ls $privparametersdir | grep -c $parameterfile` -eq 0 ]; then
	notinprivparametersdir=1
else
	notinprivparametersdir=0
fi

# if equal then config is either in both or in none of both dirs. Both not acceptable.
if [ $notinparametersdir -eq $notinprivparametersdir ] ; then
	echo "The given config is wrong. It's either in none or in both folders. Please choose one of the available configs!"
	listparameters
	#exit ${argAry1[@]}A
	exit 2
else
	# config is ok to use
	# here's the action

	# is regular
	if [ $notinparametersdir -eq 0 ]; then
		source "$parametersdir/$parameterfile"
		echo "$parametersdir/$parameterfile sourced"
		source "$devicesdir/$devicetype"
		echo "$devicesdir/$devicetype sourced"
		source "$envdir/$envfile"
		echo "$envdir/$envfile sourced"
		# part where the central config files are being distributed to subordinary scripts
	        # very ipmortant, if this file is not being distributed, node will have incomplete info
		if ( [ -f $parametersdir/$parameterfile ] && [ -d $ucidefaultspath ] ) ; then
			cp -f $parametersdir/$parameterfile $ucidefaultspath/$uciparameterfile
		else
			echo "Either parameter file at $parametersdir/$parameterfile is missing or path to uci-defaults $ucidefaultspath is wrong."
			exit 15
		fi
		if ( [ -f $envdir/$envfile ] &&  [ -d $ucidefaultspath ] ) ; then
			cp -f $envdir/$envfile $ucidefaultspath/$ucienvfile
		else
			echo "Either env file at $envdir/$envfile is missing or path to uci-defaults $ucidefaultspath is wrong."
			exit 16
		fi
	else
	# is private
		source $privparametersdir/$parameterfile
		echo "$privparametersdir/$parameterfile sourced"
		source "$privparametersdir/$devicetype"
		echo "$privparametersdir/$devicetype sourced"
		source "$privenvdir/$envfile"
		echo "$privenvdir/$envfile sourced"
		if ( [ -f $privparametersdir/$parameterfile ] && [ -d $ucidefaultspath ] ) ; then
                        cp -f $privparametersdir/$parameterfile $ucidefaultspath/$uciparameterfile
                else
                        echo "Either parameter file at $privparametersdir/$parameterfile is missing or path to uci-defaults $ucidefaultspath is wrong."
                        exit 15
                fi
		if ( [ -f $privenvdir/$envfile ] &&  [ -d $ucidefaultspath ] ) ; then
                        cp -f $privenvdir/$envfile $ucidefaultspath/$ucienvfile
                else
                        echo "Either env file at $privenvdir/$envfile is missing or path to uci-defaults $ucidefaultspath is wrong."
                        exit 16
                fi


	fi

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
	
	# distribute sourced keys from ffcp_parameter.conf into dropbear authorized_keys
	# array variable is being sourced 
	if [ -f $sshpubkeyfile ]; then
		source $sshpubkeyfile
		echo "ssh pubkeys sourced."
			for key in "${sshpubkeys[@]}"; do
			echo $key >> $dropbearkeyfiles
		done
	else
		echo "no ssh key files handled."
	fi
	echo "sshkeys done"

	echo "all done"
fi
