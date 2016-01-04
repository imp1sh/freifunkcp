# Freifunkcp
Firstly Freifunkcp is a script based solution that gives you the possibility to manage firmwares for your OpenWrt devices no matter if it's for your company or for some OpenWrt based project.
Secondly it is an OpenWrt release that is being built this environment. It is by default compatible to Freifunk (batman-adv). In the future we plan to switch to babeld if Freifunk is also making this transition.
freifunkcp stands for Freifunk ComPatible
We want to network with our neighbours, because that's the most natural thing one would want to do.

## Prebuilt images
[Download](http://images.gosix.net)

##Features##
* for every supported device there is perfected switch config
* prefconfigured networks: lan, guest, wan, mesh
* vnstat traffic monitor already setup
* Meshing via 2,4 GHz as well as 5 GHz as well as via cable already setup
* very remote devices with only one cable going to it: you don't have to compromise with features
* script: create_uci.bash is also a kind of management suite for openwrt buildroot to handle all your devices and configurations
* based upon OpenWrt Chaos Calmer stable
* able to handle all different freifunk odours (please donate config!)

## Why is this?
Freifunk aims a bit differently than us. Freifunk offers free wifi to the people, but mainly to gain access to the Internet. Our goal is to utilize this decentralized network that exists parallely to your private LAN and to the public Internet. This network we use to give the users the possibility to communicate directly with each other via this self-configuring metropolitan area network (MAN).

| origin device | origin network | transit network | destination network | destination device |
| :---: | :---: | :---: | :---: | :---: |
| user A | private LAN user A | MAN | private lan user B | user B |
There are quite a lot of details which we try to improve in order to make everything easier accessible and better usable. For example there will be a pre-configured VPN service on every device that runs on the MAN interface and that let's access their private network through the MAN. Other than that, meshing via cable is very important in freifunkcp. See ./doc/technial_info.md for background information.

## How to use this?
Please take a look into the doc directory for further information.
Usually it's like this:
* howto_buildroot -> setup the necessary environment under linux. It's been tested in Ubuntu and Debian.
* howto_build -> preparations and build

## For whom is this?
I would say for those people who aren't afraid of configuring an OpenWrt based device fully by themself. You can easily brake things by changing e.g. wifi or bridge configurations. Gluon is more targeted at the zero effort approach: less administration overhead.
If you actually like administration of routers and also like meshed networks, you are very likely to be in the right place.

## What's the overall state?
* beta 0.61
* actively searching for people to support this solution
* zabbix agent support out of the box
* [Prebuilt images](http://images.gosix.net)
* Based on Chaos Calmer stable, but you can also choose development trunk if you prefer (http://wiki.openwrt.org/about/latest)
* <strike>Map integration (alfred) status: 95 %</strike>
* Map integration (respondd) status: 0%
* Using common OpenWrt buildroot environment (http://wiki.openwrt.org/doc/howto/build)
* We currently only support TP-Link Archer C7v2, 1043v1 and TP-Link 4300 v1. More to come soon. Consider donating device if you want your device supported.

## What's not working
* This solution does not yet offer vpn/fastd at all. So currently you can only run as satellite. There are also currently no measures taken to get vpn running any time soon. Use gluon offloader or normal gluon device.
