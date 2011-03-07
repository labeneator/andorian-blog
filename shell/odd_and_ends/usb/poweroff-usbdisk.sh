#!/bin/sh
# Poweroff a device identified by the vendor/product id below.
# If you have two similar devices (e.g two western digital drives),
# the script will fail. The fix is easy: enumerate the devices
# and suspend them individually. 

vendorid=1058
productid=0704

# Look for western digital
USBDIR=$(dirname $(find  /sys/bus/usb/devices/usb[1-5]/ -iname "*vendor*"|xargs grep $vendorid|cut -f1 -d: ))

# Verify it's the hdd
grep $productid $USBDIR/idProduct

#Power off 
if [ $? -eq 0 ]; then  
	sudo umount /mnt/audio/ && echo suspend |sudo tee $USBDIR/power/level; 
fi


