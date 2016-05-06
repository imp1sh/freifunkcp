#!/bin/bash
source ffcp_variables
scriptdir="$(dirname "$0")"

function listparameters {
        echo -e "\tparameters:"
        ls $pathparameters/*.conf | awk -F'/' '{print $NF}'
        echo -e "\tprivate parameters:"
        ls $pathparameterspriv/*.conf | awk -F'/' '{print $NF}'
}

function tellhow {
	echo "First parameter give either specific parameter you want to run or all for all parameters."
	echo "Second parameter give true or false. true means you'd like to run private. If none is given both will be tried."
	echo "Parameter files need to end in *.conf"
	echo "Here's a list of parameters you can choose from:"
	listparameters
}

function compareandcopy {
	if [ -z $1 ];  then
		echo "Error. Parameter 1 not given for compareandcopy."
		return 1
	fi
	# echo "first parameter is $1"
	# first parameter has to be the variable which is if it's private or non private
	local localpathhwconfig=$1
        #if [ -f $scriptdir/../$filehwconfigbefore ]; then
        #	# new and old both there
        #	if cmp $scriptdir/$localpathhwconfig/$hwconfig $scriptdir/../$filehwconfigbefore > /dev/null 2>&1; then
        #		echo -e "\tdo cmp $scriptdir/$localpathhwconfig/$hwconfig $scriptdir/../$filehwconfigbefore. If both are the same than program is running fine here."
        #	        # new and old same content
	#		recreateconfig=false
        #	else
        #		# new and old not the same
        #		echo -e "\tdo cmp $scriptdir/$localpathhwconfig/$hwconfig $scriptdir/../$filehwconfigbefore. If both are different than program is running fine here."
        #		echo -e "\tcopying configpriv file into place"
        #		# echo "$pathcp $scriptdir/$localpathhwconfig/$hwconfig $scriptdir/../$filehwconfig"
	#		# echo "$pathcp $scriptdir/$localpathhwconfig/$hwconfig $scriptdir/../$filehwconfigbefore"
        #               $pathcp $scriptdir/$localpathhwconfig/$hwconfig $scriptdir/../$filehwconfig
	#		$pathcp $scriptdir/$localpathhwconfig/$hwconfig $scriptdir/../$filehwconfigbefore
        #       fi
        #else
                # only new file is there
                echo "$pathcp $scriptdir/$localpathhwconfig/$hwconfig $scriptdir/../$filehwconfig"
		#echo "$pathcp $scriptdir/$localpathhwconfig/$hwconfig $scriptdir/../$filehwconfigbefore"
                $pathcp $scriptdir/$localpathhwconfig/$hwconfig $scriptdir/../$filehwconfig
	#	$pathcp $scriptdir/$localpathhwconfig/$hwconfig $scriptdir/../$filehwconfigbefore
        #fi
}

function copybinfile {
	if [ -z $1 ] || [ -z $2 ]; then
		echo "Parameter 1 and/or 2 not given for copybinfile"
		return 1
	fi
	echo -e "\t### START function copybinfile ###"
	# echo parameterlocal might be wndr3700v2_firstfloor.conf or x86kvm_rick.conf or something like this
	local parameterlocal=$1
	echo -e "\tLocal Parameter: $parameterlocal"
	local parameterwithoutprefix=$(echo $parameterlocal | awk -F'.' '{print $1}')
	local parameterprefix=$(echo $parameterlocal | awk -F'.' '{print $2}')
	# hwconfiglocal might be x86kvm or c7v2 or something like this
	local binfilefull="filebin$2"
	for i in $(echo ${!binfilefull}); do
		echo -e "\t\t Doing: $i"
		if [ -f ../$pathopenwrtbin/$hwbinpath/$i ];then
        		local binwithoutsuffix=$(echo "$i" | awk -F'.' '{print $1}')
			local binsuffix=$(echo "$i" | awk -F'.' '{print $2}')
			local binnewfile=$(echo "$binwithoutsuffix-$parameterwithoutprefix.$binsuffix")
			if $ispriv; then
				echo -e "\t\t\tcopying ../$pathopenwrtbin/$hwbinpath/$i to $scriptdir/$pathbinoutpriv/$binnewfile"
				$pathcp ../$pathopenwrtbin/$hwbinpath/$i $scriptdir/$pathbinoutpriv/$binnewfile
			else
				echo -e "\t\t\tcopying ../$pathopenwrtbin/$hwbinpath/$i to $scriptdir/$pathbinout/$binnewfile"
	                	$pathcp ../$pathopenwrtbin/$hwbinpath/$i $scriptdir/$pathbinout/$binnewfile
			fi
        	else
        	        echo -e "\t\t\tError. file ../$pathopenwrtbin/$hwbinpath/$i not found."
        	        continue
        	fi
	done
	echo "### END function copybinfile ###"
}

function runparameter {
	# first parameter is the parameter file path
	# second parameter is distinctio between priv or nonpriv. Valid values are true or false. Use true if it's actually private
	if [ -z $1 ] || [ -z $2 ]; then
		echo -e "\tError. One or both parameters not given for function runparameter. Please specify."
		echo -e "\tSkipping for $1"
		return 1
	fi
	local localparameter=$1
	ispriv=$2
	if $ispriv ; then
		local parameterdir=$pathparameterspriv
	else
		local parameterdir=$pathparameters
	fi
	echo "### START $parameter ###"
	if [ ! -f $scriptdir/$parameterdir/$localparameter ]; then
		echo -e "\tError. File $scriptdir/$parameterdir/$localparameter not available"
		return 5
	fi
	source $scriptdir/$parameterdir/$localparameter
	if [ $? -ne 0 ];then
                # this is HIGHLY unlikely but not impossible
                echo -e "\t./$parameterdir/$localparameter file not there or not executeable in $shell, skipping to next parameter"
                echo "### END $localparameter ###"
                return 2
        fi
	if $ispriv; then
		if [ -f $scriptdir/$pathhwconfigpriv/$hwconfig ]; then
	                compareandcopy $(echo $pathhwconfigpriv)
	        elif [ -f $scriptdir/$pathhwconfig/$hwconfig ]; then
	                compareandcopy $(echo $pathhwconfig)
	        else
	                echo -e "\tNo hwconfig file at $scriptdir/$pathhwconfigpriv/$hwconfig nor at $scriptdir/$pathhwconfig/$hwconfig"
	                echo "### END $localparameter ###"
	                return 3
	        fi
	else
		if [ -f $scriptdir/$pathhwconfig/$hwconfig ]; then
	                compareandcopy $(echo $pathhwconfig)
	        elif [ -f $scriptdir/$pathhwconfigpriv/$hwconfig ]; then
	                compareandcopy $(echo $pathhwconfigpriv)
	        else
	                echo -e "\tNo hwconfig file at $scriptdir/$pathhwconfigpriv/$hwconfig nor at $scriptdir/$pathhwconfig/$hwconfig"
	                echo "### END $parameter ###"
	                return 4
	        fi
	fi
	# create uci
        $scriptdir/create_uci.bash $localparameter
        cd $scriptdir/..
        #if "$recreateconfig"; then
	        echo "generating full $filehwconfig from diffconfig file"
	         make defconfig  > $filehwconfig
        #fi
        echo "generating full $filehwconfig from diffconfig file"
        make defconfig  > $filehwconfig
        echo -e "\t start building with $buildthreads threads. Please be patient."
        make -j $buildthreads
        cd -
	echo "copybinfile $localparameter $hwconfig"
        copybinfile $localparameter $hwconfig
        echo "### END $localparameter ###"
	return 0
}

# no parameter given
if [ -z $1 ] && [ -z $2 ]; then
	tellhow
	exit 3
# do all parameters private and non private
elif [ $1 == "all" ] && [ -z $2 ]; then
	echo "###### START non private ######"
	ls $scriptdir/$pathparameters/*.conf &>/dev/null
	if [ $? -eq 0 ]; then
		for parameter in $(ls $scriptdir/$pathparameters/*.conf | xargs -n 1 basename); do
			runparameter ${parameter} false
		done
	else
		echo "Error. No *.conf files in $pathparameters"
	fi
	echo "###### END non private ######"

	echo "###### START private ######"
	ls $scriptdir/$pathparameterspriv/*.conf &>/dev/null
	if [ $? -eq 0 ]; then
		for parameterpriv in $(ls $scriptdir/$pathparameterspriv/*.conf | xargs -n 1 basename); do
			runparameter ${parameterpriv} true
		done
	else
		echo "Error. No *.conf files in $pathparameterspriv."
	fi
	echo "###### END non private ######"
# do all parameters but either only for private or for non-private
elif [ $1 == "all" ] && [ -n $2 ]; then
	if [ $2 == "true" ]; then
		ls $scriptdir/$pathparameterspriv/*.conf &>/dev/null
		if [ $? -eq 0 ]; then
			for parameterpriv in $(ls $scriptdir/$pathparameterspriv/*.conf | xargs -n 1 basename); do
	                        runparameter ${parameterpriv} true
	                done
		else
			echo "Error. No *.conf files in $pathparameterspriv."
		fi
	elif [ $2 == "false" ]; then
		ls $scriptdir/$pathparameters/*.conf &>/dev/null
		if [ $? -eq 0 ]; then
			for parameter in $(ls $scriptdir/$pathparameters/*.conf | xargs -n 1 basename); do
	                        runparameter ${parameter} false
	                done
		else
			echo "Error. No *.conf files in $pathparameters"
		fi
	else
		tellhow
	fi
# only first given, search for parameter and run that's found first
elif [ -n $1 ] && [ -z $2 ]; then
	specificparameter=$1
	ls $scriptdir/$pathparameters/$1 &>/dev/null
	if [ $? -eq 0 ];then
		echo "Parameter file found in $pathparameters."
		runparameter $specificparameter false
	fi
	ls $scriptdir/$pathparameterspriv/*.conf &>/dev/null
	if [ $? -eq 0 ];then
		echo "Parameter file found in $pathparameterspriv."
		runparameter $specificparameter true
	else
		"Error. File $1 not found neither in $pathparameterspriv nor in $pathparameters."
		exit 2
	fi
	exit 0
elif [ -n $1 ] && [ -n $2 ]; then
	if [ $2 == "true" ]; then
                ls $scriptdir/$pathparameterspriv/*.conf &>/dev/null
		 if [ $? -eq 0 ]; then
			runparameter $1 true
		else
			echo "Error. File $1 not found in $pathparameterspriv"
			exit 4
		fi
	elif [ $2 == "false" ]; then
		ls $scriptdir/$pathparameters/*.conf &>/dev/null
                 if [ $? -eq 0 ]; then
                        runparameter $1 false
		else
			echo "Error. File $1 not found in $pathparameters"
                        exit 5
		fi
	else
		echo "Error. in $2"
		tellhow
	fi
fi
