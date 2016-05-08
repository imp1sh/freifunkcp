# Overview
There is the branch masterfiles. Within this branch everything is being managed. You can build generic devices (ffcp_devices.d) or you can also manage your private devices (ffcp_private_devices.d).

# Main directories:
1. freifunkcp -> this is where openwrt sources reside, buildroot directory
2. env -> this is where freifunkcp sources reside, this is your main working directory

usually like this:
./freifunkcp/env/

# Setup buildroot environment
1. `git clone git://git.openwrt.org/15.05/openwrt.git freifunkcp`<br>Alternatively use lede: git clone http://git.lede-project.org/source.git freifunkcp

2. `cd freifunkcp`

3. prepare your system to be able to use openwrt buildroot env.
   Especially install necessary software.
   http://wiki.openwrt.org/doc/howto/buildroot.exigence

4. `git clone https://github.com/imp1sh/freifunkcp.git env`

5. `cp ./env/feeds.conf .`

6. `./scripts/feeds update -a`

7. `./scripts/feeds install -a`

8. `rm .config`

9. Install the right hardware config, for example x86 by invoking `cp env/ffcp_config.d/x86 .config`

10. `make defconfig`

11. Usually next step is to follow [howto_build](howto_build.md)
