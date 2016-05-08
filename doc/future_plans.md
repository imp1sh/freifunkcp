# transition to lede project
Lede is a fork or if you will a restart of what OpenWrt tried to achieve. Since some important developers of OpenWrt moved over to lede and also Freifunks gluon firmware is about to switch over to lede, we are too.

# address security concern
When installing a firmware the device might mesh to the wifi-cloud instantaneously and thus getting a a >public< but also MAN IP. There is no password set at this time an anybody can access the device via telnet with full privileges. Make sure you change the password instantaneously

# WebGUI for Freifunk
Maybe as a package that gets installed on default, that offers a new tab in LUCI just for administration of freifunk specific values like GPS information for example.

# allow https only, give possibility to include descent certificate for the firmware or environment

# pre-configured OpenVPN service for every node

# make config more flexible instead of managing so many files for different devices and for different domains and such -> use uci command instead of moving around config files

# autoupdate feature for freifunkcp official release
