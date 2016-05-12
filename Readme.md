# Freifunkcp
![Image of login screen](https://github.com/imp1sh/freifunkcp/blob/masterfiles/doc/160512_screenshot_freifunkcp.png)<br>
Firstly Freifunkcp is a script based solution that gives you the possibility to manage firmwares for your OpenWrt devices no matter if it's for your company, some OpenWrt based project or just your home device.
Secondly it is an OpenWrt release that is being built with this toolkit. It is by default compatible to Freifunk (batman-adv).
freifunkcp stands for Freifunk ComPatible
We want to network with our neighbours, because that's the most natural thing one would want to do.

## Prebuilt images
[Download](http://images.gosix.net)

##Features##
* for every supported device there is perfected switch config
* prefconfigured networks: lan, guest, wan, mesh (up to 5 point to point connections)
* vnstat traffic monitor
* Meshing via 2,4 GHz as well as 5 GHz as well as via cable
* very remote devices with only one cable going to it: you don't have to compromise with features
* script: create_uci.bash is also a kind of management suite for openwrt/lede buildroot to handle all your devices and configurations
* script: build.bash to build the firmware
* based upon OpenWrt Chaos Calmer stable / LEDE is being tested
* able to handle all different freifunk odours (please donate config!)
* seamless zabbix integration

## Why is this?
Freifunk aims a bit differently than us. Freifunk offers free wifi to the people, but mainly to gain access to the Internet. Our goal is to utilize this decentralized network that exists parallely to your private LAN and to the public Internet. This network we use to give the users the possibility to communicate directly with each other via this self-configuring metropolitan area network (MAN).
```
[user A] <---> { private LAN user A } <---> (MAN) <---> { private LAN user B } <---> [user B]
```
There are quite a lot of details which we try to improve in order to make everything easier accessible and better usable. For example there will be a pre-configured VPN service on every device that runs on the MAN interface and that let you access your private network through the MAN. Other than that, meshing via cable is very important in freifunkcp since it's more reliable and faster than radio networks. See ./doc/technial_info.md for background information.

## How to use this?
Please take a look into the doc directory for further information.
Usually it's like this:
* howto_buildroot -> setup the necessary environment under linux. It's been tested in Ubuntu and Debian.
* howto_build -> preparations and build

## For whom is this?
I would say for those people who aren't afraid of configuring an OpenWrt based device fully by themself. You can easily brake things by changing e.g. wifi or bridge configurations. Gluon is more targeted at the zero effort approach: less administration overhead.
If you actually like administration of routers and also like meshed networks, you are very likely to be in the right place.

## What's the overall state?
* testing lede-project (https://www.lede-project.org)
* actively searching for people to support this project
* [Prebuilt images](http://images.gosix.net)
* Based on Chaos Calmer stable, but you can also choose development trunk if you prefer (http://wiki.openwrt.org/about/latest)
* <strike>Map integration (alfred) status: 95 %</strike>
* Map integration (respondd) status: 0%
* Using common OpenWrt/lede buildroot environment (http://wiki.openwrt.org/doc/howto/build)
* We currently only support TP-Link Archer C7v2, 1043v1, x86kvm, x86 and TP-Link 4300 v1. More to come soon. Consider donating device if you want your device supported.

## What's not working
* This solution does not offer fastd vpn at all. If you plan to run this in a Freifunk cloud it can only run as satellite. There are no measures taken to get vpn running. Use gluon offloader or normal gluon device for that purpose.
