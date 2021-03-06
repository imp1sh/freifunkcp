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
	# this iterates through all filenames that correspond to a specific device. Those filnames are defined in an array in ffcp_variables
	for i in $(echo ${!binfilefull}); do
		echo -e "\t\t Doing: $i"
		if [ -f ../$pathopenwrtbin/$hwbinpath/generic/$i ];then
			local binbase=${i%%"."*}
			local binsuffix=${i#*"."}
			local binold=${i}
			local binnew=${binbase}-${parameterwithoutprefix}.${binsuffix}
			if $ispriv; then
				echo -e "\t\t\tcopying ../$pathopenwrtbin/$hwbinpath/generic/$binold to $scriptdir/$pathbinoutpriv/$hwbinpath/$binnew"
				$pathcp ../$pathopenwrtbin/$hwbinpath/generic/$binold $scriptdir/$pathbinoutpriv/$hwbinpath/$binnew
				echo -e "\t\t\tcopying ../$pathopenwrtbin/$hwbinpath/generic/$filechecksum to $scriptdir/$pathbinoutpriv/$hwbinpath/$filechecksum"
				$pathcp ../$pathopenwrtbin/$hwbinpath/generic/$filechecksum $scriptdir/$pathbinoutpriv/$hwbinpath/
				echo "$pathsed -i 's/$binold/$binnew/g' $scriptdir/$pathbinoutpriv/$hwbinpath/$filechecksum"
				$pathsed -i 's/$binold/$binnew/g' $scriptdir/$pathbinoutpriv/$hwbinpath/$filechecksum
			else
				echo -e "\t\t\tcopying ../$pathopenwrtbin/$hwbinpath/generic/$binold to $scriptdir/$pathbinout/$hwbinpath/$binnew"
	                	$pathcp ../$pathopenwrtbin/$hwbinpath/generic/$binold $scriptdir/$pathbinout/$hwbinpath/$binnew
				echo -e "\t\t\tcopying ../$pathopenwrtbin/$hwbinpath/generic/$filechecksum to $scriptdir/$pathbinout/$hwbinpath/$filechecksum"
				$pathcp ../$pathopenwrtbin/$hwbinpath/generic/$filechecksum $scriptdir/$pathbinout/$hwbinpath/
				echo "$pathsed -i 's/$binold/$binnew/g' $scriptdir/$pathbinout/$hwbinpath/$filechecksum"
				$pathsed -i 's/$binold/$binnew/g' $scriptdir/$pathbinout/$hwbinpath/$filechecksum
			fi
        	else
        	        echo -e "\t\t\tError. file ../$pathopenwrtbin/$hwbinpath/generic/$i not found."
        	        continue
        	fi
	done
	echo -e "\t### END function copybinfile ###"
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
	# tidy up first
	rm -f $pathuciconfig/*
	rm -f $pathucidropbear/*
	rm -f $pathucidefaults/$fileucienv
	rm -f $pathucidefaults/$fileuciparameter
	# create uci
        $scriptdir/create_uci.bash $localparameter
        cd $scriptdir/..
        #if "$recreateconfig"; then
	        echo "generating full $filehwconfig from diffconfig file"
	         make defconfig
        #fi
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
	if [ -f $scriptdir/$pathparameters/$1 ];then
		echo "Parameter file found in $pathparameters."
		runparameter $specificparameter false
	elif [ -f $scriptdir/$pathparameterspriv/$1 ];then
		echo "Parameter file found in $pathparameterspriv."
		runparameter $specificparameter true
	else
		echo "Error. File $1 not found neither in $pathparameterspriv nor in $pathparameters."
		exit 2
	fi
elif [ -n $1 ] && [ -n $2 ]; then
	if [ $2 == "true" ]; then
		 if [ -f $scriptdir/$pathparameterspriv/$1 ]; then
			runparameter $1 true
		else
			echo "Error. File $1 not found in $pathparameterspriv"
			exit 4
		fi
	elif [ $2 == "false" ]; then
                 if [ -f $scriptdir/$pathparameters/$1 ]; then
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
# after playing you have to tidy up
rm -f $pathuciconfig/*
rm -f $pathucidropbear/*
rm -f $pathucidefaults/$fileucienv
rm -f $pathucidefaults/$fileuciparameter
