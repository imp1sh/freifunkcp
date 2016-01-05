# OPENWRT  
 # VLAN
 - VLAN  3 <-> WAN
 - VLAN  5 <-> LAN
 - VLAN 11 <-> MESH (native batman-adv)
 - VLAN 12 <-> MESH guests (bridged batman-adv)

 # SWITCH
 - WAN Port - WAN - untagged VLAN 3
 - 1st Switch Port - LAN - untagged VLAN 5
 - 2nd Switch Port - MESH guests - untagged VLAN 12
 - 3rd Switch Port - MESH - untagged VLAN 11
 - 4th Switch Port - LAN+MESH+WAN+MESH guests - tagged VLAN3/5/11/12

 # DEVICES with 1 Port
 - in default configuration it is configured as MESH - untagged VLAN 11

 # Wireless
 - private network default SSID: changemySSIDandKEY -> please DO as the SSID says
 - private network is disabled by default

 # IP
 - Default IP for LAN is 192.168.1.1/24
 - By default DHCP server is enabled leases between 100 and 200

# X86 KVM
 - test1
 - test2
