---
title: "Flashing IT Firmware to the IBM-ServeRAID-M1015 SAS HBA"
date: 2018-02-11
draft: false
#thumbnail: "/images/fulls/IBM-ServeRAID-M1015.jpg"
categories: ["technology"]
tags: ["storage","linux","m1015"]
---
![image](/images/fulls/IBM-ServeRAID-M1015.jpg)
The IBM M1015 is the go to Host Bus Adapter (HBA) for enthusiasts wanting a reliable and reasonably priced HBA for systems using advanced filesystems such as ZFS. I acquired a number of these cards for my file-server upgrade. I needed cards to support my new [Norco RPC-4224 Chassis](http://www.norcotek.com/product/rpc-4224/). There is a lot of discussion on line about these cards, and re-flashing them to remove the boot & raid firmware. They are easily acquired on eBay for a reasonable cost with a little searching. I have now done this on three cards and not had any issues, however your mileage may vary.

## Removing the IBM M1015 firmware
1. Download [Rufus](https://rufus.akeo.ie/) Bootable USB Key Utility
2. Format a USB key using the Rufus tool, making sure you choose the option to make it bootable with _FreeDOS_
3. Download the SAS tools & firmware from [SAS2008](http://www.files.laptopvideo2go.com/hdd/sas2008.zip) and unzip to the USB Key
4. Boot from the key
5. Run the following commands to remove the IBM identity to allow it be be flashed with the LSI tools:

    ```
    megarec -writesbr 0 sbrempty.bin
    megarec -cleanflash 0
    ```
6. Reboot and carry on to the EFI shell below

## Using an EFI Shell to Flash your LSI9220-8i
1. Download a [x86-64 (64-bit) shell](https://edk2.svn.sourceforge.net/svnroot/edk2/trunk/edk2/ShellBinPkg/UefiShell/X64/Shell.efi) and place on the USB key. Name the file `shellx64.efi`
2. My motherboard, a ASROCK Z77 Extreme 3 has an option to **Boot to EFI shell on Removable Device**

## Using the UEFI Shell

* Use the `map` command to list block devices
* To access the USB Key, `mount fs0:`
* Then use the device name to select the device `fs0:`
* Use the DOS style `cd` and `dir` to manovure around the USB key

## Erasing the existing firmware
There are only a few steps to change your firmware. The ROM is only really required if you want to boot from a drive on this controller. Otherwise it will just slowdown your boot times as the ROM Scans the SAS bus. With a number of cards in your system, it can really add to the boot time.

1. Erase the existing firmware

    ```
    sas2flash.efi -o -e -6
    ```
2. Flash the new firmware

    To Flash **without** the optionROM:

    ```
    sas2flash.efi -o -f 2118it.bin
    ```
    With the optionROM:

    ```
    sas2flash.efi -o -f 2118it.bin -b mptsas2.rom
    ```
3. Grab the SAS address off the card, it's on the back on a green sticker (ie 500605B0xxxxxxxx)
    ```
    sas2flsh -o -sasadd 500605b0xxxxxxxx
    ```

One that is complete, the card is ready to host your disks for your ZFS filesystem.

### References
* https://forums.laptopvideo2go.com/topic/29059-sas2008-lsi92409211-firmware-files
* http://www.rodsbooks.com/refind/bootcoup.html
