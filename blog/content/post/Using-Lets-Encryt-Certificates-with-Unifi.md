---
title: "Using Let's Encrypt Certificates with Unifi"
date: 2018-04-25
draft: false
categories: ["Security"]
tags: ["unifi","lets-encrypt","ssl"]
thumbnail: "/images/2018/04/lets-encrypt-logo.png"
---
![](/images/2018/04/unifi_plus_le.png)
[Let's Encrypt](https://letsencrypt.org) is a great service that automates deployment and renewal of SSL certificates, at a bargain price. For most situations where you have a regular OS, the default [Certbot Acme](https://certbot.eff.org) client works well. However for more embedded solutions, like Ubiquiti's Unifi Cloudkey this is not an option as there is no full Linux OS. After researching a few of the alternative options, [Acme Shell](https://github.com/Neilpang/acme.sh) was the clear winner. It runs using the Bourne shell, and has Unifi support built in.

One of the concerns that I had was any software placed on the cloudkey would get wiped when upgrading the firmware. I have confirmed that files in the home directory of admin (which is really root) do not get wiped. At most, the cronjob will need to be replaced. the Acme Shell has a command to reinstall the cronjob if required.

Acme Shell supports a stack of major DNS providers. I use AWS Infrastructure which just works, YMMV

### Installation
Installing is a simple as opening an SSH session to your cloudkey and executing `curl https://get.acme.sh | sh`

Once installed, change to the `.acme.sh` directory. I need to set up my AWS keys, then execute the installation command. You will need to specify the hostname that you want the cloudkey to have, for me thats `unifi-cloudkey.ingram.net.au`

```terminal
cd .acme.sh
export  AWS_ACCESS_KEY_ID=XXXXXXXXXX
export  AWS_SECRET_ACCESS_KEY=YYYYYYYYYYYYYYYYY
./acme.sh --issue --dns dns_aws -d unifi-cloudkey.ingram.net.au
```

The following output is displayed on your console:

```terminal
[Tue Apr 24 22:50:33 +11 2018] Registering account
[Tue Apr 24 22:50:36 +11 2018] Registered
[Tue Apr 24 22:50:37 +11 2018] ACCOUNT_THUMBPRINT='-x9xTedsnDy0coEUo1XCXm0LWlzNYmBfdQzFNB4ETWU'
[Tue Apr 24 22:50:37 +11 2018] Creating domain key
[Tue Apr 24 22:50:52 +11 2018] The domain key is here: /root/.acme.sh/unifi-cloudkey.ingram.net.au/unifi-cloudkey.ingram.net.au.key
[Tue Apr 24 22:50:52 +11 2018] Single domain='unifi-cloudkey.ingram.net.au'
[Tue Apr 24 22:50:52 +11 2018] Getting domain auth token for each domain
[Tue Apr 24 22:50:52 +11 2018] Getting webroot for domain='unifi-cloudkey.ingram.net.au'
[Tue Apr 24 22:50:52 +11 2018] Getting new-authz for domain='unifi-cloudkey.ingram.net.au'
[Tue Apr 24 22:50:55 +11 2018] The new-authz request is ok.
[Tue Apr 24 22:50:55 +11 2018] Found domain api file: /root/.acme.sh/dnsapi/dns_aws.sh
[Tue Apr 24 22:51:04 +11 2018] Geting existing records for _acme-challenge.unifi-cloudkey.ingram.net.au
[Tue Apr 24 22:51:09 +11 2018] txt record updated success.
[Tue Apr 24 22:51:09 +11 2018] Sleep 120 seconds for the txt records to take effect
[Tue Apr 24 22:53:12 +11 2018] Verifying:unifi-cloudkey.ingram.net.au
[Tue Apr 24 22:53:17 +11 2018] Success
[Tue Apr 24 22:53:17 +11 2018] Removing DNS records.
[Tue Apr 24 22:53:20 +11 2018] Geting existing records for _acme-challenge.unifi-cloudkey.ingram.net.au
[Tue Apr 24 22:53:24 +11 2018] txt record deleted success.
[Tue Apr 24 22:53:24 +11 2018] Verify finished, start to sign.
[Tue Apr 24 22:53:27 +11 2018] Cert success.
-----BEGIN CERTIFICATE-----
MIIGIzCCBQugAwIBAgISA/+S0Nf1rnAPyvs7l7IBJvgtMA0GCSqGSIb3DQEBCwUA
MEoxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MSMwIQYDVQQD
ExpMZXQncyBFbmNyeXB0IEF1dGhvcml0eSBYMzAeFw0xODA0MjQxMTE2MDJaFw0x
ODA3MjMxMTE2MDJaMCcxJTAjBgNVBAMTHHVuaWZpLWNsb3Vka2V5LmluZ3JhbS5u
ZXQuYXUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDSIWvMla3zsKzb
++z6mNEuPIxEQFEfjaZvOZdFVMGzFLelmZXDjUJf4vv3oc7kx0hlPEYDP+EdjRlW
djz/iVRiIolFZcBg4asQ992hgY1cMPb6U4guP5rKDTxpZ0IZGrO9DRxkoPtNJBHM
59704z8Tr2d4SwSohGcMZieqzmLnXO60ZwGL7lX+cRPWiKIPNDvZRB41BOu1G/wF
rez29aWEypK79PpvnJre3Sd0eg2qQ19AO5F9Ytxc3FYONy84fE7suHhc3yhuaUS0
WdRqX1IRcavLwU5tj+0nrfkhlDk3BZBnOIHSov9xMwSCeKkPdk9/XupdmccThRKd
Md53aE8tAgMBAAGjggMkMIIDIDAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYI
KwYBBQUHAwEGCCsGAQUFBwMCMAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYEFJpnIeyw
a5eHSOe5maq7XhSYNOWRMB8GA1UdIwQYMBaAFKhKamMEfd265tE5t6ZFZe/zqOyh
MG8GCCsGAQUFBwEBBGMwYTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AuaW50LXgz
LmxldHNlbmNyeXB0Lm9yZzAvBggrBgEFBQcwAoYjaHR0cDovL2NlcnQuaW50LXgz
LmxldHNlbmNyeXB0Lm9yZy8wJwYDVR0RBCAwHoIcdW5pZmktY2xvdWRrZXkuaW5n
cmFtLm5ldC5hdTCB/gYDVR0gBIH2MIHzMAgGBmeBDAECATCB5gYLKwYBBAGC3xMB
AQEwgdYwJgYIKwYBBQUHAgEWGmh0dHA6Ly9jcHMubGV0c2VuY3J5cHQub3JnMIGr
BggrBgEFBQcCAjCBngyBm1RoaXMgQ2VydGlmaWNhdGUgbWF5IG9ubHkgYmUgcmVs
aWVkIHVwb24gYnkgUmVseWluZyBQYXJ0aWVzIGFuZCBvbmx5IGluIGFjY29yZGFu
Y2Ugd2l0aCB0aGUgQ2VydGlmaWNhdGUgUG9saWN5IGZvdW5kIGF0IGh0dHBzOi8v
bGV0c2VuY3J5cHQub3JnL3JlcG9zaXRvcnkvMIIBBAYKKwYBBAHWeQIEAgSB9QSB
8gDwAHcAKTxRllTIOWW6qlD8WAfUt2+/WHopctykwwz05UVH9HgAAAFi95UJ1AAA
BAMASDBGAiEAqZ8r8bodkVrf0oO68GOVcNo4qylcgawMQBXdvqRX5nUCIQCCBMNx
1yepfAhyFCrmFciNs/yxLWQ59GkYze1pdBCcVgB1ANt0r+7LKeyx/so+cW0s5bmq
uzb3hHGDx12dTze2H79kAAABYveVCbEAAAQDAEYwRAIgFJ4rvX0cq8Q+pdKIhCU/
g57uwqqaonUa8hlFmm3RwgkCIArJGAAToRnzSTLa8VS0jKmye5eXpul5LDR7S/XW
Peq1MA0GCSqGSIb3DQEBCwUAA4IBAQAEo83P2Rac0YV5JVv8i2JP9qWJjZNkH3O2
4ukUmgQxJwl1TMsBp0hAoUvLfozchUzsSCKOaQKvV00YXi2eiLTrHMhLslBnLMy2
L0U4xDTtm+nE9InRieiczRwFL9UDhu923kOEOMws+3yfkU7isVRHsVCLY9DE4oRm
6KEtBEN2fAOdMot3jOUxGIW7o4wZxWGAMSXhD5tItEtCGTIg7SboHjuE7PiUO94f
A2R4wqdayUfp1T1QQETB5G8/epAOtMUAXFuOM7MenMp/XuvebqH6LC4rqtbcVqhv
XFvvAEuYC3ruLZIbv4kVa/TglVVBHWMS4RRPFUjieOSR0VbsDjgg
-----END CERTIFICATE-----
[Tue Apr 24 22:53:27 +11 2018] Your cert is in  /root/.acme.sh/unifi-cloudkey.ingram.net.au/unifi-cloudkey.ingram.net.au.cer
[Tue Apr 24 22:53:27 +11 2018] Your cert key is in  /root/.acme.sh/unifi-cloudkey.ingram.net.au/unifi-cloudkey.ingram.net.au.key
[Tue Apr 24 22:53:28 +11 2018] The intermediate CA cert is in  /root/.acme.sh/unifi-cloudkey.ingram.net.au/ca.cer
[Tue Apr 24 22:53:28 +11 2018] And the full chain certs is there:  /root/.acme.sh/unifi-cloudkey.ingram.net.au/fullchain.cer

```

You will now have your certs in the `.acme.sh/<certname>` directory.

```terminal
root@UniFi-CloudKey:~/.acme.sh# ll ./unifi-cloudkey.ingram.net.au/
total 44
drwxr-xr-x 2 root root 4096 Apr 24 23:16 .
drwx------ 6 root root 4096 Apr 24 22:50 ..
-rw-r--r-- 1 root root 1647 Apr 24 23:16 ca.cer
-rw-r--r-- 1 root root 3834 Apr 24 23:16 fullchain.cer
-rw-r--r-- 1 root root 2187 Apr 24 23:16 unifi-cloudkey.ingram.net.au.cer
-rw-r--r-- 1 root root  546 Apr 24 23:16 unifi-cloudkey.ingram.net.au.conf
-rw-r--r-- 1 root root 1013 Apr 24 23:15 unifi-cloudkey.ingram.net.au.csr
-rw-r--r-- 1 root root  223 Apr 24 23:15 unifi-cloudkey.ingram.net.au.csr.conf
-rw-r--r-- 1 root root 1679 Apr 24 22:50 unifi-cloudkey.ingram.net.au.key
-rw-r--r-- 1 root root 4397 Apr 24 22:56 unifi-cloudkey.ingram.net.au.pfx

```
To deploy these to the unifi controller software:

```terminal
./acme.sh --deploy -d unifi-cloudkey.ingram.net.au --deploy-hook unifi
```
### Testing
One that is successful, you should be able to access your cloudkey and check the new certificate:

![](/images/2018/04/unifi_cert.png)

The Acme Shell will automatically put in a cronjob to renew the cert every three months and deploy to unifi:

```terminal
root@UniFi-CloudKey:~# crontab -l
46 0 * * * "/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" > /dev/null
```

### Certificate Renewal
To confirm that Acme Shell will automatically deploy to unifi, you can run the command from the crontab listing. Without the force option, it will not renew as the cert is still current:

```terminal
root@UniFi-CloudKey:~# "/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh"
[Tue Apr 24 23:15:39 +11 2018] ===Starting cron===
[Tue Apr 24 23:15:40 +11 2018] Renew: 'unifi-cloudkey.ingram.net.au'
[Tue Apr 24 23:15:40 +11 2018] Skip, Next renewal time is: Sat Jun 23 11:53:28 UTC 2018
[Tue Apr 24 23:15:40 +11 2018] Add '--force' to force to renew.
[Tue Apr 24 23:15:40 +11 2018] Skipped unifi-cloudkey.ingram.net.au
[Tue Apr 24 23:15:40 +11 2018] ===End cron===
```

Be careful using the `--force` option, as Let's Encrypt do throttle connections to avoid abuse. Here is the output from a force run. You will notice that the unifi deployment is automatically run at the end:
```terminal
root@UniFi-CloudKey:~# "/root/.acme.sh"/acme.sh --cron --force --home "/root/.acme.sh"
[Tue Apr 24 23:15:54 +11 2018] ===Starting cron===
[Tue Apr 24 23:15:54 +11 2018] Renew: 'unifi-cloudkey.ingram.net.au'
[Tue Apr 24 23:15:56 +11 2018] Single domain='unifi-cloudkey.ingram.net.au'
[Tue Apr 24 23:15:56 +11 2018] Getting domain auth token for each domain
[Tue Apr 24 23:15:56 +11 2018] Getting webroot for domain='unifi-cloudkey.ingram.net.au'
[Tue Apr 24 23:15:56 +11 2018] Getting new-authz for domain='unifi-cloudkey.ingram.net.au'
[Tue Apr 24 23:15:59 +11 2018] The new-authz request is ok.
[Tue Apr 24 23:16:00 +11 2018] unifi-cloudkey.ingram.net.au is already verified, skip dns-01.
[Tue Apr 24 23:16:00 +11 2018] Verify finished, start to sign.
[Tue Apr 24 23:16:03 +11 2018] Cert success.
-----BEGIN CERTIFICATE-----
MIIGIzCCBQugAwIBAgISA/+S0Nf1rnAPyvs7l7IBJvgtMA0GCSqGSIb3DQEBCwUA
MEoxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MSMwIQYDVQQD
ExpMZXQncyBFbmNyeXB0IEF1dGhvcml0eSBYMzAeFw0xODA0MjQxMTE2MDJaFw0x
ODA3MjMxMTE2MDJaMCcxJTAjBgNVBAMTHHVuaWZpLWNsb3Vka2V5LmluZ3JhbS5u
ZXQuYXUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDSIWvMla3zsKzb
++z6mNEuPIxEQFEfjaZvOZdFVMGzFLelmZXDjUJf4vv3oc7kx0hlPEYDP+EdjRlW
djz/iVRiIolFZcBg4asQ992hgY1cMPb6U4guP5rKDTxpZ0IZGrO9DRxkoPtNJBHM
59704z8Tr2d4SwSohGcMZieqzmLnXO60ZwGL7lX+cRPWiKIPNDvZRB41BOu1G/wF
rez29aWEypK79PpvnJre3Sd0eg2qQ19AO5F9Ytxc3FYONy84fE7suHhc3yhuaUS0
WdRqX1IRcavLwU5tj+0nrfkhlDk3BZBnOIHSov9xMwSCeKkPdk9/XupdmccThRKd
Md53aE8tAgMBAAGjggMkMIIDIDAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYI
KwYBBQUHAwEGCCsGAQUFBwMCMAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYEFJpnIeyw
a5eHSOe5maq7XhSYNOWRMB8GA1UdIwQYMBaAFKhKamMEfd265tE5t6ZFZe/zqOyh
MG8GCCsGAQUFBwEBBGMwYTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AuaW50LXgz
LmxldHNlbmNyeXB0Lm9yZzAvBggrBgEFBQcwAoYjaHR0cDovL2NlcnQuaW50LXgz
LmxldHNlbmNyeXB0Lm9yZy8wJwYDVR0RBCAwHoIcdW5pZmktY2xvdWRrZXkuaW5n
cmFtLm5ldC5hdTCB/gYDVR0gBIH2MIHzMAgGBmeBDAECATCB5gYLKwYBBAGC3xMB
AQEwgdYwJgYIKwYBBQUHAgEWGmh0dHA6Ly9jcHMubGV0c2VuY3J5cHQub3JnMIGr
BggrBgEFBQcCAjCBngyBm1RoaXMgQ2VydGlmaWNhdGUgbWF5IG9ubHkgYmUgcmVs
aWVkIHVwb24gYnkgUmVseWluZyBQYXJ0aWVzIGFuZCBvbmx5IGluIGFjY29yZGFu
Y2Ugd2l0aCB0aGUgQ2VydGlmaWNhdGUgUG9saWN5IGZvdW5kIGF0IGh0dHBzOi8v
bGV0c2VuY3J5cHQub3JnL3JlcG9zaXRvcnkvMIIBBAYKKwYBBAHWeQIEAgSB9QSB
8gDwAHcAKTxRllTIOWW6qlD8WAfUt2+/WHopctykwwz05UVH9HgAAAFi95UJ1AAA
BAMASDBGAiEAqZ8r8bodkVrf0oO68GOVcNo4qylcgawMQBXdvqRX5nUCIQCCBMNx
1yepfAhyFCrmFciNs/yxLWQ59GkYze1pdBCcVgB1ANt0r+7LKeyx/so+cW0s5bmq
uzb3hHGDx12dTze2H79kAAABYveVCbEAAAQDAEYwRAIgFJ4rvX0cq8Q+pdKIhCU/
g57uwqqaonUa8hlFmm3RwgkCIArJGAAToRnzSTLa8VS0jKmye5eXpul5LDR7S/XW
Peq1MA0GCSqGSIb3DQEBCwUAA4IBAQAEo83P2Rac0YV5JVv8i2JP9qWJjZNkH3O2
4ukUmgQxJwl1TMsBp0hAoUvLfozchUzsSCKOaQKvV00YXi2eiLTrHMhLslBnLMy2
L0U4xDTtm+nE9InRieiczRwFL9UDhu923kOEOMws+3yfkU7isVRHsVCLY9DE4oRm
6KEtBEN2fAOdMot3jOUxGIW7o4wZxWGAMSXhD5tItEtCGTIg7SboHjuE7PiUO94f
A2R4wqdayUfp1T1QQETB5G8/epAOtMUAXFuOM7MenMp/XuvebqH6LC4rqtbcVqhv
XFvvAEuYC3ruLZIbv4kVa/TglVVBHWMS4RRPFUjieOSR0VbsDjgg
-----END CERTIFICATE-----
[Tue Apr 24 23:16:03 +11 2018] Your cert is in  /root/.acme.sh/unifi-cloudkey.ingram.net.au/unifi-cloudkey.ingram.net.au.cer
[Tue Apr 24 23:16:03 +11 2018] Your cert key is in  /root/.acme.sh/unifi-cloudkey.ingram.net.au/unifi-cloudkey.ingram.net.au.key
[Tue Apr 24 23:16:04 +11 2018] The intermediate CA cert is in  /root/.acme.sh/unifi-cloudkey.ingram.net.au/ca.cer
[Tue Apr 24 23:16:04 +11 2018] And the full chain certs is there:  /root/.acme.sh/unifi-cloudkey.ingram.net.au/fullchain.cer
[Tue Apr 24 23:16:05 +11 2018] Generate import pkcs12
[Tue Apr 24 23:16:05 +11 2018] Modify unifi keystore: /usr/lib/unifi/data/keystore
Importing keystore /tmp/tmp.xW8LCyU2nj to /usr/lib/unifi/data/keystore...
Warning: Overwriting existing alias unifi in destination keystore

Warning:
The JKS keystore uses a proprietary format. It is recommended to migrate to PKCS12 which is an industry standard format using "keytool -importkeystore -srckeystore /usr/lib/unifi/data/keystore -destkeystore /usr/lib/unifi/data/keystore -deststoretype pkcs12".
[Tue Apr 24 23:16:10 +11 2018] Import keystore success!
[Tue Apr 24 23:16:10 +11 2018] Run reload: service unifi restart
[Tue Apr 24 23:16:24 +11 2018] Reload success!
[Tue Apr 24 23:16:25 +11 2018] Success
[Tue Apr 24 23:16:25 +11 2018] ===End cron===
```

### Redeploying the cronjob
If requried after a firmware upgrade:

```terminal
root@UniFi-CloudKey:~/.acme.sh# ./acme.sh --install-cronjob
[Wed Apr 25 15:02:37 +11 2018] Installing cron job
```

### References
- https://github.com/Neilpang/acme.sh/tree/master/deploy
- https://letsencrypt.org/
- https://letsencrypt.org/docs/client-options/
