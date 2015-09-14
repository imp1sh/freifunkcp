#!/bin/bash
# edit for your needs

# do not edit below
. ffcp_modules.conf
modulesdir=ffcp_modules.d
privmodulesdir=ffcp_private_modules.d
fullmodulesfile=allmodules.list
ucisettingsfile=./files/etc/uci-defaults/79_generated_settings

# script
if [ -f "$fullmodulesfile" ]; then
	echo "removing existing file $fullmodulesfile"
	rm -f $fullmodulesfile
fi

for module in "${ffcp_modules[@]}"; do
	cat ./$modulesdir/$module >> $fullmodulesfile
done
for privmodule in "${ffcp_private_modules[@]}"; do
	cat ./$privmodulesdir/$privmodule >> $fullmodulesfile
done

# simple check
if [ `grep -v -c "uci set" $fullmodulesfile` -ne 0 ]; then
	echo "Error in file $fullmodulesfile. Every line HAS TO contain 'uci set'"
	echo "#!/bin/ash" > $ucisettingsfile
	cat $fullmodulesfile >> $ucisettingsfile
	echo "uci commit" >> $ucisettingsfile
	echo "exit 0" >> $ucisettingsfile
	exit 1
else
	echo "done"
	exit 0
fi
