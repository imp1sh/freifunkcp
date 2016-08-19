# Overview
There is the main branch called: masterfiles. You can build generic devices (ffcp_devices.d) or you can also manage your private devices (ffcp_private_devices.d).

# Main directories:
1. freifunkcp -> this is where LEDE / OpenWrt sources reside, buildroot directory
2. env -> this is where freifunkcp sources reside, this is your main working directory

usually like this:
./freifunkcp/env/

# Setup buildroot environment
1. Prepare your system to be able to use LEDE / OpenWrt buildroot env.
   Especially install necessary software.
   http://wiki.openwrt.org/doc/howto/buildroot.exigence

2. `git clone http://git.lede-project.org/source.git freifunkcp`

3. `cd freifunkcp`

4. `git clone https://github.com/imp1sh/freifunkcp.git env`

5. `cp ./env/feeds.conf .`

6. `./scripts/feeds update -a`

7. `./scripts/feeds install -a`

8. Usually next step is to follow [howto_build](howto_build.md)
