ATTENTION
There is no logic built in that checks if you made sane selections as for your modules. Always check the configuration files after you invoked `./create_uci.bash' and before you actually build the firmware

# Automated process
- Make sure you're within env directory, ussually something like `cd ~/freifunkcp/env`
- Run `./build.bash` to see what parameter files there are you can build
- Run `./build.bash [<<parameterfile>>|all] [true|false]` where true stands for building only private devices and false for only non-private devices
- look into ffcp_bins or ffcp_private bins for your firmware to flash
- Jump to 'flash firmware'

# Manual process: Prepare - generic devices
- Make sure you're within env directory, ussually something like `cd ~/freifunkcp/env`
- If you want to provide an ssh public key to your firmware `cp sshpubkeys.template sshpubkeys` and put your key(s) into the bash array variable in there.
- `./create_uci.bash`
- It will show you the available configs. Choose one.
- There are common devices that are being managed by us, called "devices" and
- There are private devices which are for you to play with called "private devices"
- Run for example `./create_uci.bash 4300v1_default`
- This will create the default configuration files und the subdirectory 'files'
- Take a look at those files and feel free to modify to your needs before skipping to the next step.

# Manual process: Prepare - private devices
- This step is only necessary if you do not want to run through 'Manual process: Prepare - generic devices' because you want to build your own setup with a so called private device.
- Go ahead and copy a common devices file over to your ffcp_private_devices.d directory
- Modify to your needs
- Choose from whatever modules that are available in ffcp_modules.d
- Create your own modules in ffcp_private_modules.d and also feel free to select them. These are common uci configuration snippets which you can just take over from your running config

# Manual process: prepare build process - generic devices
- Depending on what target device you want copy the corresponding file like this:
- `cp ./ffcp_config.d/c7v2 .config`
- Run `make defconfig`
- check if everything is ok by looking into .config or run `make menuconfig`

# Manual process: prepare build process - private devices
- This step is only necessary if you do not want to run through 'Manual process: prepare build process - generic devices' because you want to build your own setup with a so called private device.
- Make sure you're not in env directory but one level high, usually in freifunkcp directory.
- `cp ./env//ffcp_config.d/c7v2 .config`
- Run `make menuconfig` and adjust to your needs
- FYI: The target device is chosen under "Target Profile"
- When finished, run `./scripts/diffconfig > ./env/ffcp_private_config.d/yourfilename.conf` where yourfilename is replaced with a sane name.
- When you want to utilize that file again in the future, run `cp ./env/ffcp_private_config.d/yourfilename.conf .config` and
- `make defconfig`

# Build firmware
- Run `make` - This might take some hours
- If you want to speed up, run `make -j 5` to build with 5 threads
- If something goes wrong run `make -j1 V=s` to see what went wrong
- If all fails run `make clean` and again `make`

# flash firmware
- Use numerous online guides on how to flash

# after flashing
- Login to the WebGUI which is in default at https://192.168.1.1
- Set a root password (very important)
