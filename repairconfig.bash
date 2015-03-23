#!/bin/bash
rootpath=/home/jochen/openwrt/freifunkcp

rm $rootpath/.config.old
rm $rootpath/env/.config
mv $rootpath/.config $rootpath/env/
ln -s ./env/.config .config

