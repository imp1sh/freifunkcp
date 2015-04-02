# How to upgrade firmware
## easier version
Create yourself your own git branch (./scripts/env new <<yourname>>) 
* Track your configuration changes within this branch
* When new version comes out, just do a git merge (git merge masterfiles)
* Compile
* Flash

## Pain in the ass version
* Backup your configuration files manually
* Flash new firmware without keeping old config (sysupgrade -n)
* Redo your configuration changes 
