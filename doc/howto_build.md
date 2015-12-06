# Prepare - generic devices
- Make sure you're within env directory, ussually something like `cd ~/freifunkcp/env`
- `cp ffcp_parameter.conf.template ffcp_parameter.conf`
- Review ffcp_parameters.conf
- `cp ffcp_modules.conf.template ffcp_modules.conf`
- Review ffcp_modules.conf
- Paste your ssh public key into bash array variable within "ffcp_parameter.conf" if you want to insert one or multiple keys for root user
- `./create_uci.bash`
- it will show you the available configs. Choose one.
- there are common devices that are being managed by us, called "devices" and
- there are private devices which are for you to play with called "private devices"
- run for example `./create_uci.bash 4300v1_default`
- this will create the default configuration files und the subdirectory 'files'
- take a look at those files and feel free to modify to your needs

# Prepare - private devices
- go ahead and copy a common devices file over to your ffcp_private_devices.d directory
- modify to your needs
- choose from whatever modules that are available in ffcp_modules.d
- create your own modules in ffcp_private_modules.d and also feel free to select them. These are common uci configuration snippets which you can just take over from your running config

# build process
- FYI: The target device is chosen under "Target Profile"
- `cd ..` and run `make menuconfig` and then choose target device. Exit and save
- `make` - this might take some hours
- FYI: If you with to facilitate more cores in order to speed up build process use `make -j 5' as example for 4 core CPU
- find your firmware files within "bin" directory

ATTENTION
There is no logic built in that checks if you made sane selections as for your modules. Always check the configuration files after you invoked `./create_uci.bash' and before you actually build the firmware

