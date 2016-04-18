#!/bin/bash
scriptdir="$(dirname "$0")"
dirhwconfig="ffcp_config.d"
dirhwconfigpriv="ffcp_private_config.d"
dirparameters="ffcp_parameters.d"
dirparameterspriv="ffcp_private_parameters.d"
fileconfigname=".config"
pathcp="/bin/cp"

for parameter in $(ls ffcp_parameters.d/*.conf | xargs -n 1 basename); do
	echo "runing $parameter";
	source ./$dirparameters/$parameter
	#echo "/bin/cp $scriptdir/$dirhwconfig/$hwconfig $scriptdir/../$fileconfigname"
done

for parameterpriv in $(ls ffcp_private_parameters.d/*.conf | xargs -n 1 basename); do
	echo "### START $parameterpriv ###"
	source ./$dirparameterspriv/$parameterpriv
	# put .config in place for make
	if [ $? -ne 0 ];then
		echo -e "\t./$dirparameterspriv/$parameterpriv file not there, skipping to next parameterpriv"
		continue
	fi
	echo -e "\tsource ./$dirparameterspriv/$parameterpriv"
	if [ -f $scriptdir/$dirhwconfigpriv/$hwconfig ]; then
		echo -e "\tcopying configpriv file into place"
		$pathcp $scriptdir/$dirhwconfigpriv/$hwconfig $scriptdir/../$fileconfigname
	elif [ -f $scriptdir/$dirhwconfig/$hwconfig ]; then
		echo -e "\tcopying config file into place"
		/bin/cp $scriptdir/$dirhwconfig/$hwconfig $scriptdir/../$fileconfigname
	else
		echo "$hwconfig"
		echo -e "\tNo hwconfig file at $scriptdir/$dirhwconfigpriv/$hwconfig nor at $scriptdir/$dirhwconfig/$hwconfig."
	fi
	# create uci
	$scriptdir/create_uci.bash $parameterpriv
	echo "### END $parameterpriv ###"
	cd $scriptdir/..
	echo "generating full $fileconfigname from diffconfig file"
	make defconfig  > $fileconfigname
	cd -
done
