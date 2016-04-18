#!/bin/bash
scriptdir="$(dirname "$0")"
dirhwconfig="ffcp_config.d"
dirhwconfigpriv="ffcp_private_config.d"
dirparameters="ffcp_parameters.d"
dirparameterspriv="ffcp_private_parameters.d"
fileconfigname=".config"
configbefore=".config.before"
pathcp="/bin/cp"
recreateconfig=true

function compareandcopy {
	# echo "first parameter is $1"
	# first parameter has to be the variable which is if it's private or non private
	privornot=$1
        if [ -f $scriptdir/../$configbefore ]; then
        	# new and old both there
        	if cmp $scriptdir/$privornot/$hwconfig $scriptdir/../$configbefore > /dev/null 2>&1; then
        		echo "do cmp $scriptdir/$privornot/$hwconfig $scriptdir/../$configbefore. If both are the same than program is running fine here."
        	        # new and old same content
        	        recreateconfig=false
        	else
                        # new and old not the same
                        echo "do cmp $scriptdir/$privornot/$hwconfig $scriptdir/../$configbefore. If both are different than program is running fine here."
                        echo -e "\tcopying configpriv file into place"
                        $pathcp $scriptdir/$privornot/$hwconfig $scriptdir/../$fileconfigname
			$pathcp $scriptdir/$privornot/$hwconfig $scriptdir/../$configbefore
                fi
        else
                # only new file is there
                echo -e "\tcopying configpriv to $scriptdir/../$fileconfigname"
                $pathcp $scriptdir/$privornot/$hwconfig $scriptdir/../$fileconfigname
		$pathcp $scriptdir/$privornot/$hwconfig $scriptdir/../$configbefore
        fi
}

echo "###### START non private ######"
for parameter in $(ls ffcp_parameters.d/*.conf | xargs -n 1 basename); do
	echo "### START $parameter ###"
	echo "running $parameter";
	source ./$dirparameters/$parameter
	#echo "/bin/cp $scriptdir/$dirhwconfig/$hwconfig $scriptdir/../$fileconfigname"
	echo "### END $parameter ###"
done
echo "###### END non private ######"



echo "###### START private ######"
for parameterpriv in $(ls ffcp_private_parameters.d/*.conf | xargs -n 1 basename); do
	echo "### START $parameterpriv ###"
	echo -e "\tsource ./$dirparameterspriv/$parameterpriv"
	source ./$dirparameterspriv/$parameterpriv
	# put .config in place for make
	if [ $? -ne 0 ];then
		# this is HIGHLY unlikely but not impossible
		echo -e "\t./$dirparameterspriv/$parameterpriv file not there or not executeable in $shell, skipping to next parameterpriv"
		continue
	fi
	# check if old config from build loop before is still the same
	if [ -f $scriptdir/$dirhwconfigpriv/$hwconfig ]; then 	
		compareandcopy $(echo $dirhwconfigpriv)
	elif [ -f $scriptdir/$dirhwconfig/$hwconfig ]; then
		compareandcopy $(echo $dirhwconfig)
	else
		echo -e "\tNo hwconfig file at $scriptdir/$dirhwconfigpriv/$hwconfig nor at $scriptdir/$dirhwconfig/$hwconfig"
		continue
	fi
	# create uci
	$scriptdir/create_uci.bash $parameterpriv
	cd $scriptdir/..
	if [ "$recreateconfig" = true ]; then
		echo "generating full $fileconfigname from diffconfig file"
		make defconfig  > $fileconfigname
	fi
	cd -
	echo "### END $parameterpriv ###"
done
echo "###### END non private ######"
exit 0
