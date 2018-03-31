---
title: "ZFS Disk Replacement"
date: 2018-03-31
draft: false
categories: ["technology"]
tags: ["storage","linux","zfs"]
---

An important part of setting up a new storage array is testing how to recover from common failure scenarios. This is the procedure to replace a failed drive. Documented here for a time when I might need to use the procedure in anger.

A `zpool status` showing the failed drive:
```
root@thor:/home/wayne# zpool status tank
  pool: tank
 state: DEGRADED
status: One or more devices are faulted in response to persistent errors.
        Sufficient replicas exist for the pool to continue functioning in a
        degraded state.
action: Replace the faulted device, or use 'zpool clear' to mark the device
        repaired.
  scan: scrub repaired 0 in 0h16m with 0 errors on Thu Aug 24 01:23:04 2017
config:

        NAME                                 STATE     READ WRITE CKSUM
        tank                                 DEGRADED     0     0     0
          raidz1-0                           DEGRADED     0     0     0
            ata-ST2000DL003-9VT166_5YD36NY9  ONLINE       0     0     0
            ata-ST2000DM001-1ER164_Z4Z3EKY7  ONLINE       0     0     0
            ata-ST2000DL003-9VT166_5YD39DMJ  ONLINE       0     0     0
            ata-ST2000DL003-9VT166_5YD36VR8  ONLINE       0     0     0
            ata-ST2000DL003-9VT166_5YD36W2A  FAULTED     10    14     0  too many errors

errors: No known data errors
```

Offline the drive using it's device identifier
`zpool offline tank /dev/disk/by-id/ata-ST2000DL003-9VT166_5YD36W2A`
Below is the status of the pool after offlining the drive:

```
root@thor:/home/wayne# zpool status tank
  pool: tank
 state: DEGRADED
status: One or more devices has experienced an unrecoverable error.  An
        attempt was made to correct the error.  Applications are unaffected.
action: Determine if the device needs to be replaced, and clear the errors
        using 'zpool clear' or replace the device with 'zpool replace'.
   see: http://zfsonlinux.org/msg/ZFS-8000-9P
  scan: scrub repaired 0 in 0h16m with 0 errors on Thu Aug 24 01:23:04 2017
config:

        NAME                                 STATE     READ WRITE CKSUM
        tank                                 DEGRADED     0     0     0
          raidz1-0                           DEGRADED     0     0     0
            ata-ST2000DL003-9VT166_5YD36NY9  ONLINE       0     0     0
            ata-ST2000DM001-1ER164_Z4Z3EKY7  ONLINE       0     0     0
            ata-ST2000DL003-9VT166_5YD39DMJ  ONLINE       0     0     0
            ata-ST2000DL003-9VT166_5YD36VR8  ONLINE       0     0     0
            ata-ST2000DL003-9VT166_5YD36W2A  OFFLINE     10    14     0

errors: No known data errors
```
The drive can now be physically removed and replaced with a new drive. If you have hotswap drivebays, you can move straight to onlining the drive. Otherwise you will need to rescan the scsi bus, or reboot to make the new disk available.

This array uses device ids to avoid name changes, so the new device name needs to be worked out by checking the contents of the `/dev/disk/by-id` directory:

```
root@thor:/home/wayne# ll /dev/disk/by-id/ | grep ata | grep -v part
lrwxrwxrwx 1 root root    9 Mar 31 09:35 ata-ST3250310AS_5RY0DTZN -> ../../sda
lrwxrwxrwx 1 root root    9 Mar 31 09:35 ata-ST2000DL003-9VT166_5YD36NY9 -> ../../sdc
lrwxrwxrwx 1 root root    9 Mar 31 09:35 ata-ST2000DM001-1ER164_Z4Z3EKY7 -> ../../sdb
lrwxrwxrwx 1 root root    9 Mar 31 09:35 ata-ST2000DL003-9VT166_5YD39DMJ -> ../../sdd
lrwxrwxrwx 1 root root    9 Mar 31 09:35 ata-ST2000DL003-9VT166_5YD36VR8 -> ../../sde
lrwxrwxrwx 1 root root    9 Mar 31 09:35 ata-ST2000DM001-1CH164_S1E1PXRY -> ../../sdf

```
Comparing the above output with the pool output, it can be seen that the new disk has the id `ata-ST2000DM001-1CH164_S1E1PXRY`. Replacing the drive requires specifying the removed drive, and the new drive it's replacing:

```
root@thor:/home/wayne# zpool replace tank /dev/disk/by-id/ata-ST2000DL003-9VT166_5YD36W2A /dev/disk/by-id/ata-ST2000DM001-1CH164_S1E1PXRY
```
Upon success, the status now shows the rebuild or resilvering process that will replace the drive:
```
root@thor:/home/wayne# zpool status tank
  pool: tank
 state: DEGRADED
status: One or more devices is currently being resilvered.  The pool will
        continue to function, possibly in a degraded state.
action: Wait for the resilver to complete.
  scan: resilver in progress since Sun Aug 27 16:23:52 2017
    1.04T scanned out of 8.53T at 383M/s, 5h41m to go
    213G resilvered, 12.21% done
config:

        NAME                                   STATE     READ WRITE CKSUM
        tank                                   DEGRADED     0     0     0
          raidz1-0                             DEGRADED     0     0     0
            ata-ST2000DL003-9VT166_5YD36NY9    ONLINE       0     0     0
            ata-ST2000DM001-1ER164_Z4Z3EKY7    ONLINE       0     0     0
            ata-ST2000DL003-9VT166_5YD39DMJ    ONLINE       0     0     0
            ata-ST2000DL003-9VT166_5YD36VR8    ONLINE       0     0     0
            replacing-4                        OFFLINE      0     0     0
              ata-ST2000DL003-9VT166_5YD36W2A  OFFLINE     10    14     0
              ata-ST2000DM001-1CH164_S1E1PXRY  ONLINE       0     0     0  (resilvering)

errors: No known data errors
```
