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
buildthreads=5
bindir="../bin"
binoutdir="$scriptdir/ffcp_bins"
binoutdirpriv="$scriptdir/ffcp_private_bins"
binfilec7v2="openwrt-ar71xx-generic-archer-c7-v2-squashfs-factory.bin openwrt-ar71xx-generic-archer-c7-v2-squashfs-sysupgrade.bin"
binfille4300v1="openwrt-ar71xx-generic-tl-wdr4300-v1-il-squashfs-factory.bin openwrt-ar71xx-generic-tl-wdr4300-v1-squashfs-factory.bin openwrt-ar71xx-generic-tl-wdr4300-v1-il-squashfs-sysupgrade.bin openwrt-ar71xx-generic-tl-wdr4300-v1-squashfs-sysupgrade.bin"
binfile1043v1="openwrt-ar71xx-generic-tl-wr1043nd-v1-squashfs-factory.bin openwrt-ar71xx-generic-tl-wr1043nd-v1-squashfs-sysupgrade.bin"
binfilewndr3700v1="openwrt-ar71xx-generic-wndr3700-squashfs-factory.img openwrt-ar71xx-generic-wndr3700-squashfs-factory-NA.img openwrt-ar71xx-generic-wndr3700-squashfs-sysupgrade.bin"
binfilex86kvm="openwrt-x86-kvm_guest-combined-ext4.img"

function compareandcopy {
	if [ -z $1 ];  then
		echo "Error. Parameter 1 not given for compareandcopy."
		return 1
	fi
	# echo "first parameter is $1"
	# first parameter has to be the variable which is if it's private or non private
	privornot=$1
        if [ -f $scriptdir/../$configbefore ]; then
        	# new and old both there
        	if cmp $scriptdir/$privornot/$hwconfig $scriptdir/../$configbefore > /dev/null 2>&1; then
        		echo -e "\tdo cmp $scriptdir/$privornot/$hwconfig $scriptdir/../$configbefore. If both are the same than program is running fine here."
        	        # new and old same content
        	        recreateconfig=false
        	else
                        # new and old not the same
                        echo -e "\tdo cmp $scriptdir/$privornot/$hwconfig $scriptdir/../$configbefore. If both are different than program is running fine here."
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
	local binfilefull="binfile$2"
	for i in $(echo ${!binfilefull}); do
		echo -e "\t\t Doing: $i"
		if [ -f $bindir/$hwbinpath/$i ];then
        		local binwithoutsuffix=$(echo "$i" | awk -F'.' '{print $1}')
			local binsuffix=$(echo "$i" | awk -F'.' '{print $2}')
			local binnewfile=$(echo "$binwithoutsuffix-$parameterwithoutprefix.$binsuffix")
                	echo -e "\t\t\tcopying $bindir/$hwbinpath/$i to $binoutdir/$binnewfile"
                	$pathcp $bindir/$hwbinpath/$i $binoutdir/$binnewfile
        	else
        	        echo -e "\t\t\tError. file $bindir/$hwbinpath/$i not found."
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
		continue
	fi
	local localparameter=$1
	local ispriv=$2
	if $ispriv ; then
		local parameterdir=$dirparameterspriv
	else
		local parameterdir=$dirparameters
	fi
	echo "### START $parameter ###"
	source ./$parameterdir/$localparameter
	if [ $? -ne 0 ];then
                # this is HIGHLY unlikely but not impossible
                echo -e "\t./$parameterdir/$localparameter file not there or not executeable in $shell, skipping to next parameter"
                echo "### END $localparameter ###"
                continue
        fi
	if $ispriv; then
		if [ -f $scriptdir/$dirhwconfigpriv/$hwconfig ]; then
	                compareandcopy $(echo $dirhwconfigpriv)
	        elif [ -f $scriptdir/$dirhwconfig/$hwconfig ]; then
	                compareandcopy $(echo $dirhwconfig)
	        else
	                echo -e "\tNo hwconfig file at $scriptdir/$dirhwconfigpriv/$hwconfig nor at $scriptdir/$dirhwconfig/$hwconfig"
	                echo "### END $localparameter ###"
	                continue
	        fi
	else
		if [ -f $scriptdir/$dirhwconfig/$hwconfig ]; then
	                compareandcopy $(echo $dirhwconfig)
	        elif [ -f $scriptdir/$dirhwconfigpriv/$hwconfig ]; then
	                compareandcopy $(echo $dirhwconfigpriv)
	        else
	                echo -e "\tNo hwconfig file at $scriptdir/$dirhwconfigpriv/$hwconfig nor at $scriptdir/$dirhwconfig/$hwconfig"
	                echo "### END $parameter ###"
	                continue
	        fi
	fi
	# create uci
        $scriptdir/create_uci.bash $localparameter
        cd $scriptdir/..
        if [ "$recreateconfig" = true ]; then
                echo "generating full $fileconfigname from diffconfig file"
                make defconfig  > $fileconfigname
        fi
        echo -e "\t start building with $buildthreads threads. Please be patient."
        make -j $buildthreads
        cd -
        copybinfile $localparameter $hwconfig
        echo "### END $localparameter ###"
}

echo "###### START non private ######"
for parameter in $(ls ffcp_parameters.d/*.conf | xargs -n 1 basename); do
	runparameter ${parameter} false
done
echo "###### END non private ######"



echo "###### START private ######"
for parameterpriv in $(ls ffcp_private_parameters.d/*.conf | xargs -n 1 basename); do
	runparameter ${parameterpriv} true
done
echo "###### END non private ######"
exit 0
