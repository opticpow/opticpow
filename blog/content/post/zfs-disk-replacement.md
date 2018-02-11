---
title: "Zfs Disk Replacement"
date: 2017-08-27T07:16:21Z
draft: true
---

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

Offline the drive:
`zpool offline tank /dev/disk/by-id/ata-ST2000DL003-9VT166_5YD36W2A`

Now the drive can be physically removed.

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

```
root@thor:/home/wayne# zpool replace tank /dev/disk/by-id/ata-ST2000DL003-9VT166_5YD36W2A /dev/disk/by-id/ata-ST2000DM001-1CH164_S1E1PXRY
```

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
