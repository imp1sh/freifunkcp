#!/bin/bash

sourceconfigfile=".config"
tempconfigfile="newconfig"
configpath="allconfigs"
declare -A devices
configdevicenames=( ["1043v1"]="CONFIG_TARGET_ar71xx_generic_TLWR1043" \
        ["c7v2"]="CONFIG_TARGET_ar71xx_generic_ARCHERC7" \
        ["wdr4300v1"]="CONFIG_TARGET_ar71xx_generic_TLWDR4300" )

# make sure this script isn't being executed from another directy than this one

if [ ! -f generate_allprofiles.bash ]; then
	echo "please execute this script only from the path itself."
	exit 1
fi

# create temporary config from config that comes from github. github's config file should remain unchanged
if [ -f $sourceconfigfile ]; then
	cp $sourceconfigfile $tempconfigfile
	echo "copied $sourceconfigfile to $tempconfigfile"
fi

# make sure none of the given devices is actually set
for device in "${!configdevicenames[@]}"; do
	echo "disabling device in .$tempconfigfile: $device"
	sed -i "s/${configdevicenames[$device]}.*/# ${configdevicenames[$device]} is not set/g" $tempconfigfile
done

# create configfile for every device
for device in "${!configdevicenames[@]}"; do
	echo "enabling device $device and storing it as seperate config."
	sed "s/.*${configdevicenames[$device]}.*/${configdevicenames[$device]}=y/g" $tempconfigfile > ./$configpath/$device
done

# build for every device
for deviceconfig in $(ls $configpath); do
	echo "copying configfile to build destination path."
	cp $configpath/$deviceconfig ../.config
	echo "creating uci files for device $deviceconfig"
	./create_uci.bash $deviceconfig
	cd ..
	echo "make defconfig"
	make defconfig
	echo "building, this may take some time..."
	make
	cd -
	echo "done"
done

# delete temp config
if [ -f $tempconfigfile ]; then
	rm -f $tempconfigfile
	echo "temp config file deleted"
fi
