#!/bin/sh
# Poweron a device identified by the vendor/product id below.

# Look for western digital
USBDIR=$(dirname $(find  /sys/bus/usb/devices/usb[1-5]/ -iname "*vendor*"|xargs grep $vendorid |cut -f1 -d: ))
vendorid=1058
productid=0704


# Verify it's the hdd
grep $productid $USBDIR/idProduct

#Power off 
if [ $? -eq 0 ]; then  echo on |sudo tee $USBDIR/power/level; fi


