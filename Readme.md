# Freifunkcp
Fully featured OpenWrt firmware, that's compatible to Freifunk (batman-adv).
freifunkcp stands for FreifunkComPatible

## Why is this?
Freifunk aims differently than us. Freifunk offers free wifi to the people, but mainly to gain access to the Internet. Our goal is to built another decentralized network that exists parallely to your private LAN and to the public Internet. This network should be utilized to give the users the possibility to communicate directly with each other via this self-configuring metropolitan area network (MAN). There are quite a lot of details which we try to improve in order to make everything easier accessible and better usable.

## How to use this?
Please take a look into the doc directory for further information.

## For whom is this?
I would say for those people who aren't afraid of configuring an OpenWrt based device fully by themself. You can easily brake things by changing e.g. wifi or bridge configurations. Gluon is more targeted at the zero effort approach: less administration overhead.
If you actually like administration of routers and also like meshed networks, you are very likely to be in the right place.

## What's the overall state?
* beta
* There are no official binary releases, yet.
* Firmware is compatible to Freifunk Aachen's version of gluon. (https://github.com/ffac)<br>We plan to integrate some or maybe all other versions as well.
* Based on Chaos Calmer trunk (http://wiki.openwrt.org/about/latest)
* Map integration (Alfred) status: 95 %
* Using common OpenWrt buildroot environment (http://wiki.openwrt.org/doc/howto/build)
* We currently only support TP-Link Archer C7 v2. More devices to come, soon.

## What's not working
* This solution does not yet offer vpn/fastd at all. So currently you can only run as satellite. There are also currently no measures taken to get vpn running any time soon.
