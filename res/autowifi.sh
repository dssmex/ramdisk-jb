#!/system/bin/sh
mount -o remount,rw system
#para todo lo que este en la carpeta de modulos
for x in `ls /modules/`
do
	MD5SUM1=`md5sum /modules/$x | awk {'print $1'}`
	MD5SUM2=`md5sum /system/lib/modules/$x | awk {'print $1'}`
	#Si no es igual o no existe	
	if [ "$MD5SUM1" != "$MD5SUM2" ] || [ ! -f /system/lib/modules/$x ]
	then
		#copiamos el modulo en cuestion		
		cp /modules/$x /system/lib/modules/$x
	fi
done
mount -o remount,ro system

