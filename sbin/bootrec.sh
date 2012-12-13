#!/sbin/sh
setprop service.adb.root 1
if [ -e /sbin/bootrec-device ]
then
  /sbin/bootrec-device
fi
#if recovery exist or press L or R or Vol Key
if [ -s /dev/keycheck1 -o -e /cache/recovery/boot ] || [ -s /dev/keycheck4 ] || [ -s /dev/keycheck0 ]
then
  echo 0 > /sys/class/android_usb/android0/enable
  echo 0fce > /sys/class/android_usb/android0/idVendor 
  echo 614f > /sys/class/android_usb/android0/idProduct
  echo "mass_storage,adb" > /sys/class/android_usb/android0/functions
  echo 1 > /sys/class/android_usb/android0/enable
  stop adbd

  #force enter to recovery
  if [ -e /cache/recovery/boot ]
  then
    cp /res/autowifi.sh /dev/keycheck1
  fi
  rm /cache/recovery/boot

  mount -o remount,rw rootfs /
  umount -l /system
  umount -l /data
  umount -l /cache
  umount -l /mnt/sdcard
  rm -r /sdcard
  rm -r /not/sdcard
  mkdir /sdcard
  mkdir /tmp
  rm /etc
  mkdir /etc
  cp /recovery.fstab /etc/recovery.fstab
  mount /dev/block/mmcblk0p1 /sdcard

  #if press POWER key (aroma file manager)
  if [ -s /dev/keycheck0 ]
  then 
        chmod 777 /res/aromafm/aromafm
        if [ ! -s /sdcard/aromafm_data.zip ]
        then
            cp /res/aromafm/aromafm_data.zip /sdcard/aromafm_data.zip
        fi
        if [ ! -s /sdcard/aromafm_data.zip.cfg ]
        then
            cp /res/aromafm/aromafm_data.zip.cfg /sdcard/aromafm_data.zip.cfg
        fi
        if [ ! -s /sdcard/aromafm ]
        then
            cp /res/aromafm/aromafm /sdcard/aromafm
        fi
        mount -o rw -t yaffs2 /dev/block/mtdblock0 /system
        mount -o rw -t yaffs2 /dev/block/mtdblock1 /data
        /sdcard/aromafm 1 0 /sdcard/aromafm_data.zip
        reboot

    elif [ -s /dev/keycheck1 ] || [ -s /dev/keycheck4 ]
    then
          #fix recovery swipe
          echo 0 > /sys/module/msm_fb/parameters/align_buffer
	  #if press L or R key 
	  if [ -s /dev/keycheck4 ]
	  then 
	    /res/recovery
	  fi
          #if press Vol Key 
	  if [ -s /dev/keycheck1 ]
	  then
	  	/sbin/recovery
	  fi
    fi 
fi
#Fix recovery swipe off
echo 1 > /sys/module/msm_fb/parameters/align_buffer
#continue booting

