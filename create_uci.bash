#!/bin/bash
source ffcp_variables
parameterfile="$1"

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
		cat $pathmodulespriv/$2
	fi
}
function grabarrayelement {
	declare -a argAry1=("${!1}")
	for $(echo $1element) in "${argAry1[@]}"; do
		catelement "$pathmodules" "$1"element >> "$1"file
	done
}
function listdevices {
	echo -e "\tdevices:"
	ls $pathdevices
	echo -e "\tprivate devices:"
	ls $pathdevicespriv
}
function listparameters {
	echo -e "\tparameters:"
	ls $pathparameters/*.conf | awk -F'/' '{print $NF}'
	echo -e "\tprivate parameters:"
	ls $pathparameterspriv/*.conf | awk -F'/' '{print $NF}'
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
if [ `ls $pathparameters|grep -c $parameterfile` -eq 0 ]; then
	notinpathparameters=1
else
	notinpathparameters=0
fi
if [ `ls $pathparameterspriv | grep -c $parameterfile` -eq 0 ]; then
	notinpathparameterspriv=1
else
	notinpathparameterspriv=0
fi

# if equal then config is either in both or in none of both dirs. Both not acceptable.
if [ $notinpathparameters -eq $notinpathparameterspriv ] ; then
	echo "The given config is wrong. It's either in none or in both folders. Please choose one of the available configs!"
	listparameters
	#exit ${argAry1[@]}A
	exit 2
else
	# config is ok to use
	# here's the action

	# is regular
	if [ $notinpathparameters -eq 0 ]; then
		source "$pathparameters/$parameterfile"
		echo "$pathparameters/$parameterfile sourced"
		if [ -f $pathdevices/$devicetype ]; then
			source "$pathdevices/$devicetype"
			echo "$pathdevices/$devicetype sourced"
		elif [ -f $pathdevicespriv/$devicetype ]; then
			source "$pathdevicespriv/$devicetype"
			echo "$pathdevicespriv/$devicetype sourced"
		else
			echo "Error. No device file with the name $devicetype found neither in $pathdevices nor in $pathdevicespriv."
			exit 17
		fi
		if [ -f "$pathenv/$envfile" ]; then
			source "$pathenv/$envfile"
			echo "$pathenv/$envfile sourced"
			cp -f $pathenv/$envfile $pathucidefaults/$fileucienv
		elif [ -f $pathenvpriv/$envfile ]; then
			source "$pathenvpriv/$envfile"
			echo "$pathenvpriv/$envfile sourced"
			cp -f $pathenvpriv/$envfile $pathucidefaults/$fileucienv
		else
			echo "Error. No env file with the name $envfile found neither in $pathenv nor in $pathenvpriv"
			exit 18
		fi
		# part where the central config files are being distributed to subordinary scripts
	        # very ipmortant, if this file is not being distributed, node will have incomplete info
		if  [ -d $pathucidefaults ]  ; then
			cp -f $pathparameters/$parameterfile $pathucidefaults/$fileuciparameter
		else
			echo "Either parameter file at $pathparameters/$parameterfile is missing or path to uci-defaults $pathucidefaults is wrong."
			exit 15
		fi
	else
	# is private
		source $pathparameterspriv/$parameterfile
		echo "$pathparameterspriv/$parameterfile sourced"
		if [ -f $pathdevicespriv/$devicetype ]; then
			source "$pathdevicespriv/$devicetype"
			echo "$pathdevicespriv/$devicetype sourced"
		elif [ -f $pathdevices/$devicetype ]; then
			source "$pathdevices/$devicetype"
			echo "$pathdevices/$devicetype sourced"
		else
			echo "Error. No device file with the name $devicetype found neither in $pathparameterspriv nor in $pathdevices"
			exit 20
		fi
		if [ -f $pathenvpriv/$envfile ]; then
			source "$pathenvpriv/$envfile"
			echo "$pathenvpriv/$envfile sourced"
			cp -f $pathenvpriv/$envfile $pathucidefaults/$fileucienv
		elif [ -f $pathenv/$envfile ];then
			source "$pathenv/$envfile"
			echo "$pathenv/$envfile sourced"
			cp -f $pathenv/$envfile $pathucidefaults/$fileucienv
		else
			echo "Error. No env file with the name $envfile found neither in $pathenvpriv nor in $pathenv."
			exit 21
		fi
		if ( [ -f $pathparameterspriv/$parameterfile ] && [ -d $pathucidefaults ] ) ; then
                        cp -f $pathparameterspriv/$parameterfile $pathucidefaults/$fileuciparameter
                else
                        echo "Either parameter file at $pathparameterspriv/$parameterfile is missing or path to uci-defaults $pathucidefaults is wrong."
                        exit 15
                fi
	fi

	# initialize config files
	for fileelement in $filemodulealfred $filemodulebatmanadv $filemoduledhcp $filemoduledropear $filemodulefirewall $filemodulenetwork $filemodulesystem $filemodulevnstat $filemodulewireless $pathucidropbear/$filedropbearkeys; do
		initfile $fileelement
	done
	# loop over elements
	# not working, yet
	# grabarrayelement alfred
	for alfredelement in "${alfred[@]}"; do
		catelement $pathmodules $alfredelement >> $filemodulealfred
	done
	echo "alfred done"
	for batmanadvelement in "${batmanadv[@]}"; do
		catelement $pathmodules $batmanadvelement >> $filemodulebatmanadv
	done
	echo "batmanadv done"
	for dhcpelement in "${dhcp[@]}"; do
		catelement $pathmodules $dhcpelement >> $filemoduledhcp
	done
	echo "dhcp done"
	for dropbearelement in "${dropbear[@]}"; do
		catelement $pathmodules $dropbearelement >> $filemoduledropear
	done
	echo "dropbear done"
	for firewallelement in "${firewall[@]}"; do
		catelement $pathmodules $firewallelement >> $filemodulefirewall
	done
	echo "firewall done"
	for networkelement in "${network[@]}"; do
		catelement $pathmodules $networkelement >> $filemodulenetwork
	done
	echo "network done"
	for systemelement in "${system[@]}"; do
		catelement $pathmodules $systemelement >> $filemodulesystem
	done
	echo "system done"
	for vnstatelement in "${vnstat[@]}"; do
		catelement $pathmodules $vnstatelement >> $filemodulevnstat
	done
	echo "vnstat done"
	for wirelesselement in "${wireless[@]}"; do
		catelement $pathmodules $wirelesselement >> $filemodulewireless
	done
	echo "wireless done"
	
	# distribute sourced keys from ffcp_parameter.conf into dropbear authorized_keys
	# array variable is being sourced 
	if [ -f $filesshpubkeys ]; then
		source $filesshpubkeys
		echo "ssh pubkeys sourced."
		for key in "${sshpubkeys[@]}"; do
			echo $key >> $pathucidropbear/$filedropbearkeys
		done
	else
		echo "no ssh key files handled."
	fi
	echo "sshkeys done"

	echo "all done"
fi
