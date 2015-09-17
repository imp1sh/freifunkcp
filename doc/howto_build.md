# Example with TP-Link 4300v1
- `cp ffcp_parameter.conf.template ffcp_parameter.conf`
- within ./env/ directory execute `./create_uci.bash`
- it will show you the available configs to use
- there are common devices that are being managed by us, called "devices" and
- there are private devices which are for you to play with called "private devices"
- run for example `./create_uci.bash 4300v1_default`
- this will create the default configuration files und the subdirectory 'files'
- take a look at those files and feel free to modify to your needs
# private devices
- go ahead and copy a common devices file over to your ffcp_private_devices.d directory
- modify to your needs
- choose from whatever modueles available in ffcp_modules.d
- create your own modules in ffcp_private_modules.d and also feel free to select them. These are common uci configuration snippets which you can just take over from your running config
# build process
- when you think you are finished go `cd ..` and run `make`

ATTENTION
There is no logic built in that checks if you made sane selections as for your modules. Always check the configuration files after you invoked `./create_uci.bash' and before you actually build the firmware

