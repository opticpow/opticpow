---
title: "UniFi Tips"
date: 2017-10-11T12:12:07Z
draft: true
---

* Always Shutdown your Cloudkey. It's really a linux box
* To recover from a corrupt UCK, hold down reset button until it cycles its LED between White and Blue
* Push your ssh key to the hardware using ssh-copy-id
* How to load Beta Controller firmware onto the UCK
* Set static DNS enteries into USG's dnsmasq as per below, then restart `sudo /etc/init.d/dnsmasq restart`

```shell
# /etc/dnsmasq.d/static-dns-enteries.conf

address=/fqdn/www.xxx.yyy.zzz
```

# Installing Packages on your USG

1. Add a Debian repo and the security repo:
```
configure
set system package repository wheezy components 'main contrib non-free'
set system package repository wheezy distribution wheezy
set system package repository wheezy url http://ftp.au.debian.org/debian/
commit
save
exit
```
2. Update the local cache `sudo apt-get update`
