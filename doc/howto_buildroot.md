# Overview
This is how we imagine merging and building should take place.
![Build and Merge of freifunkcp](http://www.netzkultur-aachen.de/img/150523_freifunkcp_build_merge.png)

# Main directories:
1. where you checkout openwrt, we actually use freifuncp as the directory name
./freifunkcp/ referred to as buildroot directory

2. where you checkout freifunkcp sources, we use env as directory name while it is a subdirectory of freifunkcp.
./freifunkcp/env/ referred to as freifunkcp directory

# Setup buildroot environment
1. `git clone git://git.openwrt.org/openwrt.git freifunkcp`

2. `cd freifunkcp`

3. prepare your system to be able to use openwrt buildroot env.
   Especially install necessary software.
   http://wiki.openwrt.org/doc/howto/buildroot.exigence

4. `git clone https://github.com/imp1sh/freifunkcp.git env`

5. `cp ./env/feeds.conf .`

6. `./scripts/feeds update -a`

7. `./scripts/feeds install -a`

8. `rm .config`

9. `ln -s ./env/.config .`

# Exmaple build for TP-Link Archer C7 v2
## Checkout c7 branch for tp-link archer c7 v2
1. `cd env`
2. `git checkout c7_generic`
3. `cd ..`
4. `make`

