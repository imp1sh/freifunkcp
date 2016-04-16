# OPENWRT  

 # VLAN
 - VLAN  3 <-> WAN
 - VLAN  5 <-> LAN
 - VLAN  7 <-> MESH (native batman-adv) connection 1
 - VLAN  8 <-> MESH (native batman-adv) connection 2
 - VLAN  9 <-> MESH (native batman-adv) connection 3
 - VLAN 10 <-> MESH (native batman-adv) connection 4
 - VLAN 11 <-> MESH (native batman-adv) connection 5
 - VLAN 12 <-> MESH guests (bridged batman-adv)

 # SWITCH ar71xx
 - WAN Port - WAN - untagged VLAN 3
 - 1st Switch Port - LAN - untagged VLAN 5
 - 2nd Switch Port - MESH guests - untagged VLAN 12
 - 3rd Switch Port - MESH - untagged VLAN 11
 - 4th Switch Port - LAN+MESH+WAN+MESH guests - tagged VLAN3/7-12

 # DEVICES with 1 Port
 - in default configuration it is configured as MESH - untagged VLAN 11

 # Wireless
 - private network default SSID: changemySSIDandKEY -> please DO as the SSID says
 - private network is disabled by default

 # IP
 - Default IP for LAN is 192.168.1.1/24
 - By default DHCP server is enabled leases between 100 and 200

# X86 KVM

 # Wired NIC
 - eth0 - WAN (VLAN 3)
 - eth1 - LAN (VLAN 5)
 - eth2 - guests ( VLAN 12)
 - eth3 - mesh_cable1 ( VLAN  7 )
 - eth4 - mesh_cable2 ( VLAN  8 )
 - eth5 - mesh_cable3 ( VLAN  9 )
 - eth6 - mesh_cable4 ( VLAN 10 )
 - eth7 - mesh_cable5 ( VLAN 11 )
