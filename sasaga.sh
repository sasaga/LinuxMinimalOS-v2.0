#!/bin/bash
#proyecto LinuxMinimal sistema linux minimo
#Autor: Samir Sanchez Garnica (by:sasaga)
#twitter @sasaga92
#
#
#

#    Copyright (C) <2016>  <samir sanchez garnica>

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


# Ruta de almacenamiento de datos para la compilaacion del sistema
WORK_PATH_ACTUAL=$(pwd)
WORK_PATH="/tmp/SASAGA/"
WORK_PATH_COMPILER="/tmp/SASAGA/src"
WORK_PATH_COMPILER_ROOTFS="/tmp/SASAGA/src/rootfs"
WORK_PATH_COMPILER_ROOTFS_LIB="/tmp/SASAGA/src/rootfs/lib"
WORK_PATH_CREATE="/tmp/SASAGA/src/live"
WORK_PATH_FICHERO_DOWNLOAD="/tmp/SASAGA/DOWNLOAD"


#Colores manejados para el script
blanco="\033[1;37m"
gris="\033[0;37m"
magenta="\033[0;35m"
rojo="\033[1;31m"
verde="\033[1;32m"
amarillo="\033[1;33m"
azul="\033[1;34m"
rescolor="\e[0m"





#header del script, pantalla de bienvenida del sistema de compilacion...
function mostrarheader(){

	echo -e "$verde############################################################"
	echo -e "$verde#                                                          #"
	echo -e "$verde#$rojo		 LinuxMinimal $version" "${amarillo}by ""${azul}SASAGA""$verde                   #"
	echo -e "$verde#""${rojo}	S""${amarillo}ASAGA" "${rojo}N""${amarillo}o" "${rojo}E""${amarillo}s un ""${rojo}F""${amarillo}ramework ""${rojo}De" "${rojo}S""${amarillo}istemas" "${rojo}O""${amarillo}perativos""$verde   #"
	echo -e "$verde#                                                          #"
	echo -e "$verde############################################################""$rescolor"
	echo
	echo
}
mostrarheader


############################################## < INICIO > ##############################################


# pedimos acceso de root para poder ejecutar el script


if ! [ $(id -u) = "0" ] 2>/dev/null; then
	echo -e "\e[1;31mUsted no tiene suficientes privilegios"$rescolor""
	exit
fi

# Si se cierra el script inesperadamente, ejecutar la funcion inmediatamente
trap exitmode SIGINT

function exitmode {
	echo -e "\n\n"$blanco"["$rojo"-"$blanco"] "$rojo"Ejecutando la limpieza y cerrando."$rescolor""
	if [ ! -d $WORK_PATH ]; then
		exit
else
	rm -R $WORK_PATH
	echo -e ""$blanco"["$verde"+"$blanco"] "$verde"Limpiza efectuada con exito!"$rescolor""
	exit
fi
}





# Crear carpeta de trabajo
if [ ! -d $WORK_PATH ]; then

	for directory in $WORK_PATH $WORK_PATH_COMPILER $WORK_PATH_COMPILER_ROOTFS $WORK_PATH_COMPILER_ROOTFS_LIB $WORK_PATH_FICHERO_DOWNLOAD
	do
		mkdir $directory
	done

else
	if [ -d $WORK_PATH ]; then
		comprobar=$(find $WORK_PATH | wc -l)
        dir=5
		if [ "$comprobar" != "$dir" ]; then
     	  echo -e "\e[1;31mHubo algun error al crear directorio de trabajo"$rescolor""
	      exitmode
	    fi
   fi

fi


# comprobar conexion a internet   y descargamos dependencias faltantes, en caso de que alla acceso a internet
function checkRed {
   echo -ne "Comprobando_conexion_a_internet....."$rescolor""
   WGET="/usr/bin/wget"
   $WGET -q --tries=10 --timeout=5 http://www.google.com.co -O /tmp/index.google &> /dev/null
   if [ ! -s /tmp/index.google ];then
       echo -e "\e[1;31mNo esta Conectado"$rescolor""
       echo -e "\e[1;31mImposible descargar dependencias"$rescolor""

   else
       echo -e "\e[1;32mOK!"$rescolor""
        dep1=$(sed -e '/xterm/ !d' $WORK_PATH_FICHERO_DOWNLOAD/list.txt)
        dep2=$(sed -e '/genisoimage/ !d' $WORK_PATH_FICHERO_DOWNLOAD/list.txt)
        dep3=$(sed -e '/gzip/ !d' $WORK_PATH_FICHERO_DOWNLOAD/list.txt)
        dep4=$(sed -e '/strip/ !d' $WORK_PATH_FICHERO_DOWNLOAD/list.txt)
        dep5=$(sed -e '/cpio/ !d' $WORK_PATH_FICHERO_DOWNLOAD/list.txt)
        dep6=$(sed -e '/tar/ !d' $WORK_PATH_FICHERO_DOWNLOAD/list.txt)

        for i in /bin /sbin /usr/bin /usr/sbin ; do

             if [ -f $i/yast ]; then
                  encontrado="yast"
             fi

             if [ -f $i/yast2 ]; then
                  encontrado="yast2"
             fi

             if [ -f $i/yum ]; then
                  encontrado="yum"
             fi

             if [ -f $i/pacman ]; then
                  encontrado="pacman"
             fi

             if [ -f $i/apt-get ]; then
                  encontrado="apt-get"
             fi

             if [ -f $i/zipper ]; then
                  encontrado="zipper"
             fi

             if [ -f $i/emerge ]; then
                  encontrado="emerge"
             fi

       done

	    if [ -n "$dep1" ]; then
	    	echo -e  $azul"instalando dependencias faltantes por favor espere"$rescolor
            gnome-terminal -x  $encontrado install xterm  2> /dev/null &
        fi

        if [ -n "$dep2" ]; then
	    	echo -e $azul"instalando dependencias faltantes por favor espere"$rescolor
            xterm -title "install genisoimage"  -e $encontrado install genisoimage &

        fi

        if [ -n "$dep3" ]; then
	    	echo -e $azul"instalando dependencias faltantes por favor espere"$rescolor
            xterm -title "install gzip"  -e $encontrado install gzip &

        fi

        if [ -n "$dep4" ]; then
	    	echo -e $azul"instalando dependencias faltantes por favor espere"$rescolor
            xterm -title "install strip"  -e $encontrado install strip&

        fi

        if [ -n "$dep5" ]; then
	    	echo -e $azul"instalando dependencias faltantes por favor espere"$rescolor
            xterm -title "install cpio"  -e $encontrado install cpio &

        fi

        if [ -n "$dep6" ]; then
	    	echo -e $azul"instalando dependencias faltantes por favor espere"$rescolor
            xterm -title "install tar"  -e $encontrado install tar &

        fi
   fi

	 sleep 1
	 exitmode

}

#checamos las dependecias para poder llevar con exito la construccion
function checkdependences {
	echo "Verificando dependencias"
	echo -ne "xterm....."
	if ! hash xterm 2>/dev/null; then
		echo -e "\e[1;31mNo esta Instalado"$rescolor""
		echo "xterm" >> $WORK_PATH_FICHERO_DOWNLOAD/list.txt
		salir=1
	else
		echo -e "\e[1;32mOK!"$rescolor""
	fi
	sleep 0.025
	echo -ne "genisoimage....."
	if ! hash genisoimage 2>/dev/null; then
		echo -e "\e[1;31mNo esta Instalado"$rescolor""
		echo "genisoimage " >> $WORK_PATH_FICHERO_DOWNLOAD/list.txt
		salir=1
	else
		echo -e "\e[1;32mOK!"$rescolor""
	fi
	sleep 0.025
	echo -ne "Gzip....."
	if ! hash gzip 2>/dev/null; then
		echo -e "\e[1;31mNo esta Instalado"$rescolor""
		salir=1
	else
		echo -e "\e[1;32mOK!"$rescolor""
	fi
	sleep 0.025
	echo -ne "strip....."
	if ! hash strip 2>/dev/null; then
		echo -e "\e[1;31mNo esta Instalado"$rescolor""
		salir=1
	else
		echo -e "\e[1;32mOK!"$rescolor""
	fi
	sleep 0.025
	echo -ne "cpio....."
	if ! hash cpio 2>/dev/null; then
		echo -e "\e[1;31mNo esta Instalado"$rescolor""
		salir=1
	else
		echo -e "\e[1;32mOK!"$rescolor""
	fi
	sleep 0.025
	echo -ne "tar....."
	if ! hash tar 2>/dev/null; then
		echo -e "\e[1;31mNo esta Instalado"$rescolor""
		salir=1
	else
		echo -e "\e[1;32mOK!"$rescolor""
	fi

	sleep 1
	if [ "$salir" = "1" ]; then
		if [ -f $WORK_PATH_FICHERO_DOWNLOAD/list.txt ]; then
			echo -e "\e[1;31mFaltan algunas dependencias"$rescolor""
			checkRed

		fi

	fi
}
checkdependences





#copiamos y compilamos busybox
function compilacion {
	echo -e "$verde############################################################"
	echo -e "$verde#            ${rojo}C${amarillo}ONFIGURACION ${rojo}D${amarillo}E ${rojo}B${amarillo}U${rojo}S${amarillo}YBOX   ${verde}                   #"
	echo -e "$verde############################################################"
	if [ ! -d app ]; then
		echo -e "\e[1;31mVerifique que exista el directorio app"$rescolor""
		exitmode
	else
	    tar -xf app/core/busybox-1.22.1.tar.bz2 -C $WORK_PATH_COMPILER
        cp -a $WORK_PATH_COMPILER/busybox-1.22.1/* $WORK_PATH_COMPILER_ROOTFS
        rm -R $WORK_PATH_COMPILER/busybox-1.22.1/
        echo -e "$amarillo copia y compilacion Busybox \e[1;32mOK!"$rescolor""
        sleep 1
fi


if [ ! -f $WORK_PATH_COMPILER_ROOTFS/init ]; then
	rm $WORK_PATH_COMPILER_ROOTFS/linuxrc
	cd $WORK_PATH_COMPILER_ROOTFS/
	ln -s bin/busybox init
	echo -e "$amarillo configuracion Busybox \e[1;32mOK!"$rescolor""
	sleep 1

else

		echo -e "\e[1;31mEl Archivo init ya existe "$rescolor""
		sleep 0.025
fi




 cd $WORK_PATH_ACTUAL
if [ ! -d app ]; then
	echo -e "\e[1;31mVerifique que exista el directorio app"$rescolor""
		exitmode
else
	cp app/addon_glibc* $WORK_PATH_COMPILER_ROOTFS
  xz -d $WORK_PATH_COMPILER_ROOTFS/addon_glibc*
  tar -x -f $WORK_PATH_COMPILER_ROOTFS/addon_glibc-*.tar -C $WORK_PATH_COMPILER_ROOTFS
	strip $WORK_PATH_COMPILER_ROOTFS_LIB/*
	echo -e "$amarillo Copiando Librerias \e[1;32mOK!"$rescolor""
	rm -rf $WORK_PATH_COMPILER_ROOTFS/addon_glibc-*.tar
	sleep 1
	clear
fi


}
compilacion

#creamos nuestra jerarquia de directorios
function jerarquia {
	echo -e "$verde############################################################"
	echo -e "$verde#            ${rojo}C${amarillo}REANDO ${rojo}J${amarillo}ERARQUIA ${rojo}D${amarillo}E ${rojo}D${amarillo}IRECTORIOS   ${verde}           #"
	echo -e "$verde############################################################"
	for var in dev etc etc/init.d etc/rc.d etc/rc.scripts root home proc media mnt sys tmp var usr lib lib/iptables usr/lib usr/local usr/games usr/share usr/share/doc usr/share/kmap usr/share/udhcpc var/cache var/lib var/lock var/log /var/log/lighttpd var/games var/run var/spool var/www var/tmp media/cdrom media/flash media/usbdisk
	  do
	    mkdir -p  $WORK_PATH_COMPILER_ROOTFS/$var
	    echo -e "$amarillo directorio:  $var \e[1;32mOK!"$rescolor""
	    sleep 0.5
	done
	chmod 1777 $WORK_PATH_COMPILER_ROOTFS/tmp
	echo -e $amarillo"Aplicando Permisos a $rojo temp  \e[1;32mOK!"$rescolor""
	sleep 1
	clear
}
jerarquia


function copiar_app {
	if [ ! -d app ]; then
		echo -e "\e[1;31mVerifique que exista el directorio app"$rescolor""
		exitmode
	else
    cp -a $WORK_PATH_ACTUAL/app/* $WORK_PATH_COMPILER_ROOTFS/etc/init.d/
fi
}
copiar_app


#creamos los ficheros para configuracion de algunas herramientas
function CrearFicherosAplicaciones {
	echo -e "$verde############################################################"
	echo -e "$verde#            ${rojo}C${amarillo}REANDO ${rojo}F${amarillo}ICHEROS ${rojo}P${amarillo}ARA ${rojo}A${amarillo}PLICACIONES   ${verde}         #"
	echo -e "$verde############################################################"
	touch $WORK_PATH_COMPILER_ROOTFS/etc/ld.so.conf
	if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/ld.so.conf ]; then
		echo -e "\e[1;31mFichero: ld.so.conf no creado error"$rescolor""
		sleep 0.025
	else
	echo -e "$amarillo Fichero: ld.so.conf  \e[1;32mOK!"$rescolor""
	sleep 0.5
	fi
  if [ ! -e $WORK_PATH_COMPILER_ROOTFS/etc/profile ]; then
    PATH=/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
    echo PATH=$PATH > $WORK_PATH_COMPILER_ROOTFS/etc/profile
		echo '''
		if [ "`id -u`" -eq 0 ]; then
			PS1="\[\e[0;31m\]\u@\h:\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[0;31m\]\#\[\e[m\]\[\e[0;32m\]"
		else
			PS1="\[\e[0;32m\]\u@\h:\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\]\[\e[1;37m\]"
		fi
		''' >> $WORK_PATH_COMPILER_ROOTFS/etc/profile
  fi
	if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/profile ]; then
		echo -e "\e[1;31mHubo un error al crear PROFILE"$rescolor""
		exitmode
	else
	echo -e "$amarillo Fichero: profile \e[1;32mOK!"$rescolor""
	sleep 0.5
	fi

	echo -e "$amarillo Dispositivos en :  /dev  \e[1;32mOK!"$rescolor""
	sleep 0.5
	clear
    cd $WORK_PATH_COMPILER_ROOTFS/dev


    ##################### creamos los dispositivos del directorio /dev #########################


    # make usfull directories.
    for dis in pts input net usb shm
    do
    	mkdir $dis
    done

    #
    #
    mknod input/event0 c 13 64
    mknod input/event1 c 13 65
    mknod input/event2 c 13 66
    mknod input/mouse0 c 13 32
    mknod input/mice c 13 63
    mknod input/ts0 c 254 0

    # miscellaneous one-of-a-kind stuff.
    #
    mknod logibm c 10 0
    mknod psaux c 10 1
    mknod inportbm c 10 2
    mknod atibm c 10 3
    mknod console c 5 1
    mknod full c 1 7
    mknod kmem c 1 2
    mknod mem c 1 1
    mknod null c 1 3
    mknod port c 1 4
    mknod random c 1 8
    mknod urandom c 1 9
    mknod zero c 1 5
    mknod rtc c 10 135
    mknod sr0 b 11 0
    mknod sr1 b 11 1
    mknod agpgart c 10 175
    mknod dri c 10 63
    mknod ttyS0 c 4 64
    mknod audio c 14 4
    mknod beep c 10 128
    mknod ptmx c 5 2
    mknod nvram c 10 144
    ln -s /proc/kcore core

    # net/tun device
    #
    mknod net/tun c 10 200

    # framebuffer devs.
    #
    mknod fb0 c 29 0
    mknod fb1 c 29 32
    mknod fb2 c 29 64
    mknod fb3 c 29 96
    mknod fb4 c 29 128
    mknod fb5 c 29 160
    mknod fb6 c 29 192

    # usb/hiddev
    #
    mknod usb/hiddev0 c 180 96
    mknod usb/hiddev1 c 180 97
    mknod usb/hiddev2 c 180 98
    mknod usb/hiddev3 c 180 99
    mknod usb/hiddev4 c 180 100
    mknod usb/hiddev5 c 180 101
    mknod usb/hiddev6 c 180 102

    # IDE HD devs
    # with a fiew concievable partitions; you can do
    # more of them yourself as you need 'em.
    #

    # hda devs
    #
    mknod hda b 3 0
    mknod hda1 b 3 1
    mknod hda2 b 3 2
    mknod hda3 b 3 3
    mknod hda4 b 3 4
    mknod hda5 b 3 5
    mknod hda6 b 3 6
    mknod hda7 b 3 7
    mknod hda8 b 3 8
    mknod hda9 b 3 9

    # hdb devs
    #
    mknod hdb b 3 64
    mknod hdb1 b 3 65
    mknod hdb2 b 3 66
    mknod hdb3 b 3 67
    mknod hdb4 b 3 68
    mknod hdb5 b 3 69
    mknod hdb6 b 3 70
    mknod hdb7 b 3 71
    mknod hdb8 b 3 72
    mknod hdb9 b 3 73

    # hdc and hdd with cdrom symbolic link.
    #
    mknod hdc b 22 0
    mknod hdd b 22 64
    ln -s hdc cdrom

    # sda devs
    #
    mknod sda  b 8 0
    mknod sda1 b 8 1
    mknod sda2 b 8 2
    mknod sda3 b 8 3
    mknod sda4 b 8 4
    mknod sda5 b 8 5
    mknod sda6 b 8 6
    mknod sda7 b 8 7
    mknod sda8 b 8 8
    mknod sda9 b 8 9
    ln -s sda1 flash

    # sdb devs
    #
    mknod sdb b 8 16
    mknod sdb1 b 8 17
    mknod sdb2 b 8 18
    mknod sdb3 b 8 19
    mknod sdb4 b 8 20
    mknod sdb5 b 8 21
    mknod sdb6 b 8 22
    mknod sdb7 b 8 23
    mknod sdb8 b 8 24
    mknod sdb9 b 9 25

    # Floppy device.
    #
    mknod fd0 b 2 0

    # loop devs
    #
    for i in `seq 0 7`; do
    	mknod loop$i b 7 $i
    done

    # ram devs
    #
    for i in `seq 0 7`; do
    	mknod ram$i b 1 $i
    done
    ln -s ram1 ram

    # tty devs
    #
    mknod tty c 5 0
    for i in `seq 0 7`; do
    	mknod tty$i c 4 $i
    done

    # virtual console screen devs
    #
    for i in `seq 0 7`; do
    	mknod vcs$i b 7 $i
    done
    ln -s vcs0 vcs

    # virtual console screen w/ attributes devs
    #
    for i in `seq 0 7`; do
    	mknod vcsa$i b 7 $i
    done
    ln -s vcsa0 vcsa


    # Symlinks.
    #
    ln -snf /proc/self/fd fd
    ln -snf /proc/self/fd/0 stdin
    ln -snf /proc/self/fd/1 stdout
    ln -snf /proc/self/fd/2 stderr

    # cambio de permisos.
    #
    echo -e "$amarillo cambiando permisos a dispositivos \e[1;32mOK!"$rescolor""
    chmod 0666 ptmx
    chmod 0666 null
    chmod 0622 console
    chmod 0666 tty*


    # fin del script
    echo -e "$amarillo dispositivos creados exitosmente  \e[1;32mOK!"$rescolor""
    cd $WORK_PATH_ACTUAL

    #########################
}
CrearFicherosAplicaciones

#creamos el fichero del sistema
echo -e "$verde############################################################"
	echo -e "$verde#            ${rojo}C${amarillo}REANDO ${rojo}F${amarillo}ICHEROS ${rojo}P${amarillo}ARA ${rojo}S${amarillo}ISTEMA   ${verde}              #"
	echo -e "$verde############################################################"
function FicheroSistemas {
	#fichero host
	if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/hosts ]; then
    echo "127.0.0.1 localhost sasagaOS" > $WORK_PATH_COMPILER_ROOTFS/etc/hosts
    echo -e "$amarillo Fichero: hosts  \e[1;32mOK!"$rescolor""
    sleep 0.5
else
		echo -e "\e[1;31mEl Fichero: hosts ya existe "$rescolor""
		sleep 0.025

fi
#fichero networks
if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/networks ]; then
    echo "localnet 127.0.0.1" > $WORK_PATH_COMPILER_ROOTFS/etc/networks
    echo -e "$amarillo Fichero: networks \e[1;32mOK!"$rescolor""
    sleep 0.5

else

		echo -e "\e[1;31mEl Fichero:  networks ya existe "$rescolor""
		sleep 0.025

fi

#fichero network.conf
if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/network.conf ]; then
    echo '''
					# /etc/network.conf: configuracion de red sasagaOS.
					# Config file used by: /etc/rc.scripts/network.sh
					#

					# Set default interface.
					INTERFACE="eth0"

					# Dynamic IP address.
					# Enable/disable DHCP client at boot time.
					DHCP="yes"

					# Static IP address.
					# Enable/disable static IP at boot time.
					STATIC="no"

					# Set IP address, and netmask for a static IP.
					IP="192.168.1.6"
					NETMASK="255.255.255.0"

					# Set route gateway for a static IP.
					GATEWAY="192.168.1.1"

					# Set DNS server. for a static IP.
					DNS_SERVER="192.168.1.1"
			''' > $WORK_PATH_COMPILER_ROOTFS/etc/network.conf

    echo -e "$amarillo Fichero: network.conf \e[1;32mOK!"$rescolor""
    sleep 0.5
else
		echo -e "\e[1;31mEl Fichero:  network.conf ya existe "$rescolor""
		sleep 0.025

fi

#fichero network.sh
if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/rc.scripts/network.sh ]; then
		echo '''
		#!/bin/sh
		# /etc/rc.scripts/network.sh: inicializacion de la red al inicio.
		# Config file is: /etc/network.conf
		#
		. /etc/init.d/rc.functions
		. /etc/network.conf

		# Set hostname.
		echo -n "Configurando Hostaname... "
		/bin/hostname -F /etc/hostname
		status

		# Configure loopback interface.
		echo -n "Configurando loopback... "
		/sbin/ifconfig lo 127.0.0.1 up
		/sbin/route add 127.0.0.1 lo
		status

		# For a dynamic IP with DHCP.
		if [ "$DHCP" = "yes" ] ; then
		echo "Inicializando udhcpc client on: $INTERFACE... "
		/sbin/udhcpc -b -i $INTERFACE -p /var/run/udhcpc.$INTERFACE.pid
		fi

		# For a static IP.
		if [ "$STATIC" = "yes" ] ; then
		echo "Configurando IP estatica en $INTERFACE: $IP... "
		/sbin/ifconfig $INTERFACE $IP netmask $NETMASK up
		/sbin/route add default gateway $GATEWAY
		echo "nameserver $DNS_SERVER" > /etc/resolv.conf
		fi
		''' > $WORK_PATH_COMPILER_ROOTFS/etc/rc.scripts/network.sh

		echo -e "$amarillo Fichero: network.sh  \e[1;32mOK!"$rescolor""
    sleep 0.5
		echo -e "$amarillo Permisos:network.sh \e[1;32mOK!"$rescolor""
		chmod +x $WORK_PATH_COMPILER_ROOTFS/etc/rc.scripts/network.sh
		sleep 0.5
else
		echo -e "\e[1;31mEl Fichero: network.sh ya existe "$rescolor""
		sleep 0.025

fi

#fichero host.conf
if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/host.conf ]; then
	echo "order hosts,bind" > $WORK_PATH_COMPILER_ROOTFS/etc/host.conf
	echo "multi on" >> $WORK_PATH_COMPILER_ROOTFS/etc/host.conf
		echo -e "$amarillo Fichero: host.conf  \e[1;32mOK!"$rescolor""
        sleep 0.5
else
		echo -e "\e[1;31mEl Fichero: host.conf ya existe "$rescolor""
		sleep 0.025

fi

#fichero rc.conf
if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/rcS.conf ]; then
		echo '''
			# /etc/rcS.conf: Configuracion inicial de inicio.
			# Config file used by: /etc/init.d/rcS
			#
			# Start Kernel log daemons.
			KERNEL_LOG_DAEMONS="yes"
			SYSLOGD_ROTATED_SIZE="60"
			KERNEL_VERSION=4.7.3

			# Utilizar udev para poblar /dev y gestiona los eventos de conexión hotplug.
			MDEV="yes"

			# Limpiar el sistema de eliminación de todos los archivos temporales y PID.
			CLEAN_UP_SYSTEM="yes"

			# Pre login message.
			MESSAGE="Bienvenido a sasagaOS."
			''' > $WORK_PATH_COMPILER_ROOTFS/etc/rcS.conf

		echo -e "$amarillo Fichero: rc.conf  \e[1;32mOK!"$rescolor""
        sleep 0.5
else
		echo -e "\e[1;31mEl Fichero: rc.conf ya existe "$rescolor""
		sleep 0.025

fi


#fichero hostname
if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/hostname ]; then
    echo "sasagaOS" > $WORK_PATH_COMPILER_ROOTFS/etc/hostname
    echo -e "$amarillo Fichero: hostname \e[1;32mOK!"$rescolor""
    sleep 0.5
else
		echo -e "\e[1;31mEl Fichero: hostname ya existe "$rescolor""
		sleep 0.025
fi

#fichero nsswitch.conf

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/nsswitch.conf ]; then
    echo -e "$amarillo Fichero: nsswitch.conf \e[1;32mOK!"$rescolor""
		for i in passwd group shadow networks; do
			echo "$i: files" >> $WORK_PATH_COMPILER_ROOTFS/etc/nsswitch.conf
		done
		echo "hosts: files dns" >> $WORK_PATH_COMPILER_ROOTFS/etc/nsswitch.conf
		sleep 0.5
else
	echo -e "\e[1;31mEl Fichero: nsswitch.conf ya existe "$rescolor""
	sleep 0.025
fi

#creamos fichero securetty

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/securetty ]; then
echo """
# nano etc/securetty
# /etc/securetty: Lista de terminales en los que se permite acceder a la raíz.
console
# Para las personas con las consolas de puerto serie
ttyS0
# Consolas Estandar
""" > $WORK_PATH_COMPILER_ROOTFS/etc/securetty
				for x in 1 2 3 4 5 6 7; do
					echo "tty"$x >> $WORK_PATH_COMPILER_ROOTFS/etc/securetty
				done
    		echo -e "$amarillo Fichero: securetty \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero:  securetty ya existe "$rescolor""
	sleep 0.025
fi
#creamos ficheros shells

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/shells ]; then

echo """
# nano etc/shells
# /etc/shells: shells de login validos.
/bin/sh
/bin/ash
/bin/hush
    """ > $WORK_PATH_COMPILER_ROOTFS/etc/shells
    echo -e "$amarillo Fichero: shells \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero:  shells ya existe "$rescolor""
	sleep 0.025
fi

#creamos fichero issue

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/issue ]; then
	echo "sasagaOS GNU/Linux 2.0 Kernel \r \l" > $WORK_PATH_COMPILER_ROOTFS/etc/issue
    echo -e "$amarillo Fichero: issue \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero:  issue ya existe "$rescolor""
	sleep 0.025
fi

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/motd ]; then

echo """
# nano etc/motd
(°- { Obtenga la documentacion de construccion  en: /usr/share/doc.
//\ Uso: menos o más para leer los archivos, 'su' ser root}
v_/_ SASAGA
""" > $WORK_PATH_COMPILER_ROOTFS/etc/motd
    echo -e "$amarillo Fichero: motd \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero: motd ya existe "$rescolor""
	sleep 0.025
fi

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/busybox.conf ]; then
 echo """
# /etc/busybox.conf: sasagaOS GNU/linux Configuracion Busybox.
#
[SUID]
#Permitir orden a ejecutar por cualquier persona.
su = ssx root.root
passwd = ssx root.root
loadkmap = ssx root.root
mount = ssx root.root
reboot = ssx root.root
halt = ssx root.root
""" > $WORK_PATH_COMPILER_ROOTFS/etc/busybox.conf
      #chmod 600 $WORK_PATH_COMPILER_ROOTFS/etc/busybox.conf
    echo -e "$amarillo Fichero: busybox.conf \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero: busybox.conf ya existe "$rescolor""
	sleep 0.025
fi


if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/inittab ]; then
	echo "::sysinit:/etc/init.d/rcS" > $WORK_PATH_COMPILER_ROOTFS/etc/inittab
	for i in 1 2 3 4 5 6; do
		echo "tty$i::respawn:getty 38400 tty$i" >> $WORK_PATH_COMPILER_ROOTFS/etc/inittab
	done
	echo "::restart:/etc/init.d/rc.shutdown" >> $WORK_PATH_COMPILER_ROOTFS/etc/inittab
	echo "::restart:/sbin/init" >> $WORK_PATH_COMPILER_ROOTFS/etc/inittab
	echo "::ctrlaltdel:/sbin/reboot" >> $WORK_PATH_COMPILER_ROOTFS/etc/inittab
	echo "::shutdown:/etc/init.d/rc.shutdown" >> $WORK_PATH_COMPILER_ROOTFS/etc/inittab

    echo -e "$amarillo Fichero: inittab \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl  Fichero: inittab ya existe "$rescolor""
	sleep 0.025
fi

#creamos fichero passwd, shadow group gshadow

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/passwd ]; then
    echo "root:x:0:0:root:/root:/bin/sh" > $WORK_PATH_COMPILER_ROOTFS/etc/passwd
		echo "www:x:80:80:www:/var/www:/bin/sh" >> $WORK_PATH_COMPILER_ROOTFS/etc/passwd
    echo -e "$amarillo Fichero: passwd \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero:  passwd ya existe "$rescolor""
	sleep 0.025
fi


if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/init.d ]; then
    echo '''
		#!/bin/sh

		# /etc/init.d/rc.shutdown: Este script es utilizado por /etc/inittab para detener
		# Todos los demonios y apagar el sistema.
		#
		. /etc/init.d/rc.functions

		echo ""
		echo ""
		echo "------------------------------------------------------------------------------"
		echo -e "\033[1m  El Sistema se está cerrando para  reiniciarse o detenerse.\033[0m"
		echo "------------------------------------------------------------------------------"
		echo ""

		# Stop all daemons with scripts in /etc/rc.d.
		echo "Detener todos los demonios y scripts en /etc/init.d..."
		for i in /etc/rc.d/*
		do
			if [ -x $i ]; then
				$i stop
			fi
		done

		# Sync all file systems.
		echo -n "Sincronizando todos los archivos del sistema... "
		sync
		sleep 2
		status

		# Swap off.
		echo -n "Desactivando espacio de SWAP... "
		/sbin/swapoff -a
		status

		# Umount file systems.
		echo -n "desmontar todos los sistemas de archivos... "
		/bin/umount -a -r
		status
		''' >  $WORK_PATH_COMPILER_ROOTFS/etc/init.d/rc.shutdown
    echo -e "$amarillo Fichero: rc.shutdown \e[1;32mOK!"$rescolor""
    sleep 0.5
		echo -e "$amarillo Permisos: rc.shutdown \e[1;32mOK!"$rescolor""
		chmod +x $WORK_PATH_COMPILER_ROOTFS/etc/init.d/rc.shutdown
		sleep 0.5
else
	echo -e "\e[1;31mEl  Fichero: rc.shutdown ya existe "$rescolor""
	sleep 0.025
fi


if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/shadow ]; then
    echo "root::13525:0:99999:7:::" > $WORK_PATH_COMPILER_ROOTFS/etc/shadow
		echo "www:*:13509:0:99999:7:::" >> $WORK_PATH_COMPILER_ROOTFS/etc/shadow
		echo "www:*:13509:0:99999:7:::" >> $WORK_PATH_COMPILER_ROOTFS/etc/shadow-
    echo -e "$amarillo Fichero: shadow \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero: shadow ya existe "$rescolor""
	sleep 0.025
fi

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/init.d/rc.functions ]; then
    echo '''
		# /etc/init.d/rc.functions:  scripts boot sasagaOS.
		#
		#
		#Colores manejados para el script
		blanco="\033[1;37m"
		gris="\033[0;37m"
		magenta="\033[0;35m"
		rojo="\033[1;31m"
		verde="\033[1;32m"
		amarillo="\033[1;33m"
		azul="\033[1;34m"
		rescolor="\e[0m"

		# funcion estado
		status()
		{
			local CHECK=$?
				echo -en "\033[68G"
				if [ $CHECK = 0 ] ; then
					echo -e "$verde OK!"$rescolor""
				else
					echo -e "$rojo fallo!"$rescolor""
				fi
		}
		'''>$WORK_PATH_COMPILER_ROOTFS/etc/init.d/rc.functions
		echo -e "$amarillo Fichero: rc.functions \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero: shadow ya existe "$rescolor""
	sleep 0.025
fi


if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/group ]; then
    echo "root:x:0:" > $WORK_PATH_COMPILER_ROOTFS/etc/group
    echo -e "$amarillo Fichero: group \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero:  group ya existe "$rescolor""
	sleep 0.025
fi

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/gshadow ]; then
    echo "root:*::" > $WORK_PATH_COMPILER_ROOTFS/etc/gshadow
    echo -e "$amarillo Fichero: gshadow \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero: gshadow ya existe "$rescolor""
	sleep 0.025
fi

#aplicamos permisos a gshadow y shadow

for per in shadow gshadow
do
	#chmod 640 $WORK_PATH_COMPILER_ROOTFS/etc/$per
	echo -e "$amarillo Permisos:$per \e[1;32mOK!"$rescolor""


done

#creamos fichero fstab
if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/fstab ]; then
echo """
# /etc/fstab: information about static file system.
#

proc       /proc         proc       	 defaults     0        0
sysfs      /sys          sysfs     		 defaults     0        0
devpts     /dev/pts      devpts     	 defaults     0        0
tmpfs      /dev/shm      tmpfs      	 defaults     0        0
/dev/cdrom /media/cdrom  auto ro


""" > $WORK_PATH_COMPILER_ROOTFS/etc/fstab
    echo -e "$amarillo Fichero: fstab \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero: fstab ya existe "$rescolor""
	sleep 0.025
fi

#creamos enlace simbolico a mtab

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/mtab ]; then
	ln -s /proc/mounts $WORK_PATH_COMPILER_ROOTFS/etc/mtab
    echo -e "$amarillo Enlace a: mtab \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEnlace a:  mtab  ya existe "$rescolor""
	sleep 0.025
fi

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/usr/share/kmap/fr_CH.kmap ]; then
	$WORK_PATH_COMPILER_ROOTFS/bin/busybox dumpkmap > $WORK_PATH_COMPILER_ROOTFS/usr/share/kmap/fr_CH.kmap
    echo -e "$amarillo Configuracion teclado: KMAP \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mConfiguracion teclado: KMAP  ya existe "$rescolor""
	sleep 0.025
fi

#copiando default.script
if [ ! -f $WORK_PATH_COMPILER_ROOTFS/usr/share/udhcpc/default.script ]; then
    cp ficheros/simple.script $WORK_PATH_COMPILER_ROOTFS/usr/share/udhcpc/default.script
    echo -e "$amarillo defult.script ==> udhcpc \e[1;32mOK!"$rescolor""
    chmod +x $WORK_PATH_COMPILER_ROOTFS/usr/share/udhcpc/default.script
     echo -e "$amarillo Aplicando permisos defult.script ==> udhcpc \e[1;32mOK!"$rescolor""
    sleep 0.025
else
	echo -e "\e[1;31mArchivo defult.script ==> udhcpc  ya existe "$rescolor""
	sleep 1
fi

if [ ! -d $WORK_PATH_COMPILER_ROOTFS/etc/dropbear ]; then
		mkdir -p $WORK_PATH_COMPILER_ROOTFS/etc/dropbear
fi

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/rc.d/dropbear ];then
	echo '''
	#!/bin/sh
	# /etc/init.d/dropbear: Start, stop, restart and status servidor SSH
	#
	# Para iniciar el servidor SSH en el arranque, basta con crear un enlace simbólico
	# from this script to /etc/rc.d/dropbear with this command:
	# de esta secuencia de comandos  /etc/rc.d/dropbear
	# ln -s /etc/init.d/dropbear /etc/rc.d/60dropbear
	#
	. /etc/init.d/rc.functions

	NAME=Dropbear
	DESC="SSH server"
	DAEMON=/usr/sbin/dropbear
	OPTIONS="-w -g"
	PIDFILE=/var/run/dropbear.pid

	case "$1" in
	  start)
	    # We need rsa and dss host key file to start dropbear.
	    if [ ! -f /etc/dropbear/dropbear_rsa_host_key ] ; then
	      echo "Generando $NAME llave RSA... "
	      dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
	    fi
	    if [ ! -f /etc/dropbear/dropbear_dss_host_key ] ; then
	      echo "Generando $NAME llave RSS... "
	      dropbearkey -t dss -f /etc/dropbear/dropbear_dss_host_key
	    fi
	    if [ -f $PIDFILE ] ; then
	      echo "$NAME esta corriendo."
	      exit 1
	    fi
	    echo -n "Starting $DESC: $NAME... "
	    $DAEMON $OPTIONS
	    status
	    ;;
	  stop)
	    if [ ! -f $PIDFILE ] ; then
	      echo "$NAME no esta corriendo."
	      exit 1
	    fi
	    echo -n "Stopping $DESC: $NAME... "
	    kill `cat $PIDFILE`
	    status
	    ;;
	  restart)
	    if [ ! -f $PIDFILE ] ; then
	      echo "$NAME no esta corriendo."
	      exit 1
	    fi
	    echo -n "Reiniciando $DESC: $NAME... "
	    kill `cat $PIDFILE`
	    sleep 2
	    $DAEMON $OPTIONS
	    status
	    ;;
		status)
			if pidof dropbear | sed "s/$$\$//" | grep -q [0-9] ; then
		echo $NAME" esta corriendo"
			else
		echo $NAME" esta detenido"
			fi
			;;
	  *)
	    echo ""
	    echo -e "\033[1mUso:\033[0m /etc/init.d/`basename $0` [start|stop|restart]"
	    echo ""
	    exit 1
	    ;;
	esac

	exit 0
 '''>$WORK_PATH_COMPILER_ROOTFS/etc/rc.d/dropbear
		chmod +x $WORK_PATH_COMPILER_ROOTFS/etc/rc.d/dropbear
		sleep 0.5
		 echo -e "$amarillo Fichero: dropbear  \e[1;32mOK!"$rescolor""
else
echo -e "\e[1;31mFichero:   dropbear  ya existe "$rescolor""
sleep 0.025
fi

if [ ! -d $WORK_PATH_COMPILER_ROOTFS/etc/lighttpd ]; then
	mkdir -p $WORK_PATH_COMPILER_ROOTFS/etc/lighttpd
	echo '''
	# /etc/lighttpd/lighttpd.conf: sasagaOS LightTPD
	# Archivo de configuracion del servidor
	#
	#

	# Documentos root.
	#
	server.document-root = "/var/www/"

	# Puerto, defecto para trafico http es 80.
	#
	server.port = 80

	# Usuario y grupo del servidor.
	#
	server.username = "www"
	server.groupname = "www"

	# Cabecera del servidor.
	# Hay que ser agradable y lo mantendra a lighttpd y sasagaOS
	#
	server.tag = "lighttpd/1.4.41 (sasagaOS GNU/Linux)"

	# istados de directorios.
	#
	dir-listing.activate = "enable"
	dir-listing.encoding = "iso8859-1"

	# Archivo para abrir de forma predeterminada.
	#
	index-file.names = ( "index.shtml", "default.shtml",
                        "index.html",  "default.html",
                        "index.php",   "default.php",
                        "index.erb",   "default.erb",
                        "index.rb",    "default.rb",
                        "index.pl",    "default.pl",
												"index.py", "default.py" )

	## File Compression for faster page loading ##

	compress.cache-dir = "/var/log/lighttpd/"

	compress.filetype = ("text/plain",
                     	"text/html",
                     	"text/css",
                     	"text/xml",
											"text/javascript" )
	# Log mensajes.
	#
	accesslog.filename = "/var/log/lighttpd/access.log"
	server.errorlog  = "/var/log/lighttpd/error.log"

	# archivo PID del servidor
	#
	server.pid-file = "/var/run/lighttpd.pid"

	# MIME type.
	#
	mimetype.assign = (
	  ".html" => "text/html",
	  ".txt" => "text/plain",
	  ".js" => "text/javascript",
	  ".css" => "text/css",
	  ".xml" => "text/xml",
	  ".log" => "text/plain",
	  ".conf" => "text/plain",
	  ".pdf" => "application/pdf",
	  ".jpg" => "image/jpeg",
	  ".jpeg" => "image/jpeg",
	  ".png" => "image/png",
	  ".gif" => "image/gif",
	  ".xbm" => "image/x-xbitmap",
	  ".xpm" => "image/x-xpixmap",
	  ".gz" => "application/x-gzip",
	  ".tar.gz" => "application/x-tgz",
	  ".tazpkg" => "application/x-tazpkg",
	  ".torrent" => "application/x-bittorrent",
	  ".ogg" => "application/ogg",
	)

	# Denegar el acceso a los archivos-extensiones.
	#
	url.access-deny = ( "~", ".inc" )

	# Módulos para cargar.
	# Ver  /usr/lib/lighttpd para ver  todos los módulos disponibles.
	#

	server.modules = ( "mod_simple_vhost",
								     "mod_rewrite",
								     "mod_access",
								     "mod_auth",
								     "mod_fastcgi",
								     "mod_cgi",
								     "mod_ssi",
								     "mod_accesslog",
								     "mod_expire",
								     "mod_alias",
								     "mod_userdir",
								     "mod_status",
								     "mod_compress",
								     "mod_setenv",
		 							 	 "mod_proxy" )

	# módulo de directorio de usuarios.
	#
	userdir.path = "public"
	userdir.exclude-user = ("root")

	# Estados del modulo.
	#
	status.status-url = "/server-status"


	# Alias urls for localhost.
	$HTTP["remoteip"] =~ "127.0.0.1" {
	  alias.url += (
	    "/doc/" => "/usr/share/doc/"
	  )
	}

	# CGI module.
	$HTTP["url"] =~ "/cgi-bin/" {
	  cgi.assign = (
	    ".sh" => "/bin/sh",
	    ".cgi" => "/bin/sh"
	  )
	}

	# hosts virtuales.
	#
	# Si desea carga de alojamiento virtual host virtual cargar mod_simple_vhost
	#
	# Se puede comentar la línea siguiente para gestionar el alojamiento virtual
	# en un archivo separado.
	#
	#include /etc/lighttpd/vhost.conf

	# Example.com
	#
	#$HTTP["host"] =~ "(^|\.)example\.com$" {
	  #server.document-root = "/var/www/vhost/exemple.com/html"
	  #server.errorlog = "/var/log/lighttpd/example-error.log"
	  #accesslog.filename = "/var/log/lighttpd/example-access.log"
	#}


'''>$WORK_PATH_COMPILER_ROOTFS/etc/lighttpd/lighttpd.conf
sleep 0.5
 echo -e "$amarillo Fichero: lighttpd  \e[1;32mOK!"$rescolor""
else
echo -e "\e[1;31mFichero:  lighttpd  ya existe "$rescolor""
sleep 0.025
fi

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/rc.d/lighttpd ]; then
echo '''
#!/bin/sh
# /etc/rc.d/lighttpd: Start, stop y restart servidor web
# en sasagaOS, durante el inicio o con la línea de comandos.
#
. /etc/init.d/rc.functions

NAME=LightTPD
DESC="web server"
DAEMON=/usr/sbin/lighttpd
OPTIONS="-f /etc/lighttpd/lighttpd.conf"
PIDFILE=/var/run/lighttpd.pid

case "$1" in
start)
	if [ -f $PIDFILE ] ; then
		echo "$NAME ya esta corriendo..."
		exit 1
	fi
	echo -n "Iniciando $DESC: $NAME... "
	$DAEMON $OPTIONS
	status
	;;
stop)
	if [ ! -f $PIDFILE ] ; then
		echo "$NAME no esta corriendo..."
		exit 1
	fi
	echo -n "deteniendo $DESC: $NAME... "
	kill `cat $PIDFILE`
	rm $PIDFILE
	status
	;;
restart)
	if [ ! -f $PIDFILE ] ; then
		echo "$NAME no esta corriendo."
		exit 1
	fi
	echo -n "Reiniciando $DESC: $NAME... "
	kill `cat $PIDFILE`
	rm $PIDFILE
	sleep 2
	$DAEMON $OPTIONS
	status
	;;
*)
	echo ""
	echo -e "\033[1mUso:\033[0m /etc/init.d/`basename $0` [start|stop|restart]"
	echo ""
	exit 1
	;;
esac

exit 0
'''>$WORK_PATH_COMPILER_ROOTFS/etc/rc.d/lighttpd
chmod +x $WORK_PATH_COMPILER_ROOTFS/etc/rc.d/lighttpd
sleep 0.5
 echo -e "$amarillo Fichero: demonio para lighttpd  \e[1;32mOK!"$rescolor""
else
echo -e "\e[1;31mFichero:  demonio lighttpd  ya existe "$rescolor""
sleep 0.025
fi

#creando el archivo index.html server
if [ ! -f $WORK_PATH_COMPILER_ROOTFS/var/www/index.html ]; then
echo '''
<!DOCTYPE html>
<html lang="es">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1,maximun-scale=1">
	<title>LinulMinimalOS</title>
	<style>
		@@import "https://fonts.googleapis.com/css?family=Jura";
		*{
			margin: 0;
			padding: 0;
		}
		body{
			background-color: gainsboro;
		}
		section.contendor-titulo{
			position: absolute;
			top: 50%;
			transform: translateY(-50%);
			-webkit-transform: translateY(-50%);
			-moz-transform: translateY(-50%);
			-ms-transform: translateY(-50%);
			-o-transform: translateY(-50%);
			left: 50%;
			-webkit-transform: translatex(-50%);
			-moz-transform: translatex(-50%);
			-ms-transform: translatex(-50%);
			-o-transform: translatex(-50%);
			display: table;
			width: auto;
			font-weight: normal;
			font-size: 3em;
			color: gray;
			font-family: "Jura","sans-serif";
			letter-spacing: 0px;
		}
		p span{
			font-size: .5em;
		}
	</style>
</head>
<body>
	<section class="contendor-titulo">
		<p>LinuxMinimalOS<span> v2.0</span></p>
	</section>
</body>
</html>

	'''  >$WORK_PATH_COMPILER_ROOTFS/var/www/index.html
		sleep 0.5
			 echo -e "$amarillo Fichero: index.html \e[1;32mOK!"$rescolor""
else
echo -e "\e[1;31mFichero:  index.html ya existe "$rescolor""
sleep 0.025
fi

#creando el archivo de arranque rcS
if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/init.d/rcS ]; then
  echo '''
    #! /bin/sh
    # /etc/init.d/rcS: rcS DEMONIO INICIAL.
    #
		. /etc/init.d/rc.functions
		. /etc/rcS.conf
		clear
		# Start by sleeping a bit.
		echo -e "$amarillo Procesando $azul /etc/init.d/rcS $rescolor... "
		status
		sleep 2


		addgroup -g 80 www
		chown www.www /var/log/lighttpd
		clear

		# ***********
		# LOGS & PIDS
		# ***********
		 echo -e " $amarillo configurando  $azul LOGS & PIDS $rescolor del sistema..."
		 syslogd >/dev/null 2>&1
		 klogd -c 3
		 dmesg > /var/log/boot.log
		#
		#
		#
		status

		# *****
		# BASH
		# *****
		 echo -e "$amarillo Los item $azul BASH $rescolor estan siendo procesados.."
		 sed -i '"'/bash/d'"' /etc/shells
		 if [ -e /usr/bin/bash ]; then
			 echo /bin/bash >> /etc/shells
			 if [ ! -e $HOME/.bashrc ]; then
					echo export PS1="\[\e[0;31m\]\u@\h:\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[0;31m\]\$\[\e[m\]\[\e[0;32m\]" > $HOME/.bashrc
				 sed -i '"'s/ash/bash/g'"' /etc/passwd
			 fi
		 fi
		 #
		 #
		 status

		 # **********
		 # AUTOMOUNT
		 # **********
			echo -e "$amarillo Configuraciones  $azul AUTOMOUNT $rescolor estan siendo procesados..."
			echo "# Disks to mount during the boot time:" > /tmp/automount
			echo MOUNT_HARD_DISK=yes >> /tmp/automount
			echo MOUNT_REMOVABLE_DISK=yes >> /tmp/automount
			echo MOUNT_CDROM_DISK=no >> /tmp/automount
			. /tmp/automount
			if [ ! -e /etc/automount.conf ]; then
				cat /tmp/automount > /etc/automount.conf
			fi
			rm /tmp/automount
			. /etc/automount.conf
		 #
		 #
		 #
		 status


		# Mount /proc.
		echo -e "$amarillo Montando archivos del sistema $azul proc $rescolor ... "
		/bin/mount proc
		status

		# Comprobar sistema de archivos raíz si sasagaOS está instalado en HD.
		# Buscamos /init utilizado en el modo directo, si el archivo no dosis
		# Existe, comenzamos e2fsck en /dev/root.
		if [ ! -f /init ] ; then
		  echo -e "$amarillo Checkeando $rojo root file system $rescolor... "
		  mount -o remount,ro /
		  /sbin/e2fsck -p /dev/root
		fi
		status

		# Remount rootfs rw.
		echo -e "$amarillo Remontando $rojo rootfs read/write $rescolor... "
		/bin/mount -o remount,rw /
		status

		# montar todo a partir de  /etc/fstab.
		echo -e "$amarillo Montando todo desde $azul fstab $rescolor... "
		/bin/mount -a
		status

		if [ "$KERNEL_LOG_DAEMONS" = "yes" ] ; then
		  # Start syslogd
		  echo -e "$amarillo Inicializando $azul demonio system log: syslogd $rescolor... "
		  /sbin/syslogd -s $SYSLOGD_ROTATED_SIZE
		  status
		  # Start klogd.
		  echo -e "$amarillo Inicializando $azul demonio kernel log: klogd $rescolor... "
		  /sbin/klogd
		  status
		else
		  echo -e "$rojo demonio de registro del núcleo están desactivados en/etc/rc.conf... $rescolor "
		fi

		if [ "$MDEV" = "yes" ] ; then
			# Configuración del nucleo a eventos de conexion en caliente con hotplug y mdev
  		# start mdev -s to populate /dev.
			echo -e "$amarillo Configuración del kernel para eventos  $azul mdev hotplug $rescolor... "
		  echo "/sbin/mdev" > /proc/sys/kernel/hotplug
		  status
		  echo -e "$amarillo Inicializando $azul mdev -s para probar /dev $rescolor... "
		  /sbin/mdev -s
		  status
		else
		  echo -e "$rojo mdev esta desactivado en $amarillo /etc/rc.conf $rescolor... "
		fi

		if [ "$CLEAN_UP_SYSTEM" = "yes" ] ; then
		  # Limpiar el sistema de.
		  echo -e "$amarillo limpiando el sistema de $azul Temporales $rescolor... "
		  rm -rf /tmp/*
		  rm -f /var/run/*.pid
		  status
		else
		  echo -e "$rojo Limpieza del sistema desactivado en $blanco /etc/rc.conf $rescolor... "
		  echo -e "$amarillo Mantener todos los archivos $azul temporales y pid $rescolor... "
		  status
		fi



  # ***********
  # SOPORTE XZ
  # ***********

  echo -e "$amarillo El soporte de elemento $azul XZ $rescolor se está procesando..."
  mkdir /tmp 2>/dev/null
  XZ=unistalled
  cp /etc/init.d/addon_glibc* /tmp/glibc.tar.xz 2>/dev/null
  if [ -e /tmp/glibc.tar.xz ]; then
    busybox xz -d /tmp/glibc.tar.xz
    busybox tar -x -f /tmp/glibc.tar -C /
    rm -f /tmp/glibc.tar
    cp /etc/init.d/addon_xz* /tmp/xz.tar.xz 2>/dev/null
    if [ -e /tmp/xz.tar.xz ]; then
      busybox xz -d /tmp/xz.tar.xz
      busybox tar -x -f /tmp/xz.tar -C /
      rm -f /tmp/xz.tar
      XZ=installed
    fi
  fi
	status

	# **********************
  # AGREGAR NUEVOS ADDONS
  # **********************

  echo -e "$amarillo procediendo a instalar los $azul ADDONS $rescolor"

  mkdir /var/sasagaOS 2>/dev/null
  mv /etc/init.d/core /var/sasagaOS 2>/dev/null
  ADDON_LIST=$(ls /etc/init.d/addon_*.tar.xz 2>/dev/null)
  for i in $ADDON_LIST; do
    echo -e "$rojo => $azul instalando  $blanco $i $rescolor"
    if [ $XZ = installed ]; then
      xz -k -d $i
      mv $i /var/sasagaOS
      else
      cp -f $i /var/sasagaOS
      busybox xz -d $i
    fi
    tar -x -f /etc/init.d/*.tar -C /
    rm /etc/init.d/*.tar
		status
  done
	#
	#
	#

	# *********
	# HARD DISK
	# *********
	echo -e "$amarillo Los item $azul HARD DISK $rescolor estan siendo procesados..."
	cd /dev
	rmdir /mnt/* 2>/dev/null
	if [ -e /dev/sda ]; then
		for i in $(ls sda*) ; do
			mkdir /mnt/$i 2>/dev/null
			rmdir /mnt/sda 2>/dev/null
			if [ -e /dev/root ]; then
				rmdir /mnt/$(readlink root) 2>/dev/null
			fi
			if [ $MOUNT_HARD_DISK = yes ]; then
				ntfs-3g /dev/$i /mnt/$i 2>/dev/null
				mount /dev/$i /mnt/$i 2>/dev/null
				rmdir /mnt/* 2>/dev/null
			fi
			if [ -e /mnt/$i ]; then
				echo "/dev/$i /mnt/$i auto rw" >> /etc/fstab
			fi
		done
	fi
	status
	#
	#
	#



 # ******************
 # DISCOS REMOVIBLES
 # ******************
	echo -e "$amarillo Los item para $azul discos removibles $rescolor estan siendo procesados..."
	mkdir /media/disk 2>/dev/null
	rmdir /media/disk/* 2>/dev/null
  cd /dev
	if [ -e /dev/sda ]; then
		for i in $(ls sd* | grep -v sda); do
			mkdir /media/disk/$i 2>/dev/null
			if [ $MOUNT_REMOVABLE_DISK = yes ]; then
				ntfs-3g /dev/$i /media/disk/$i 2>/dev/null
				mount /dev/$i /media/disk/$i 2>/dev/null
				rmdir /media/disk/* 2>/dev/null
			fi
			if [ -e /media/disk/$i ]; then
				echo "/dev/$i /media/disk/$i auto rw" >> /etc/fstab
			fi
		done
	fi
 #
 #
 #
 status


# ************
# OPTICAL DISC
# ************
 echo -e "$amarillo Los itemns para $azul discos opticos $rescolor estan siendo procesados..."
 cd /dev
 if [ -e sr0 ]; then
	 for i in cdrom bluray dvd; do
		 ln -sf sr0 /media/$i
	 done
	 cd /media
	 rm bluray 2>/dev/null
	 ln -s cdrom bluray
	 rm dvd 2>/dev/null
	 ln -s cdrom dvd
	 cd /dev
	 if [ $MOUNT_CDROM_DISK = yes ]; then
		 mount /dev/cdrom
	 fi
 fi
#
#
#
status

# **************
# SWAP PARTITION
# **************
echo -e "$amarillo peocesando los itemns para  $azul /etc/swap.conf $rescolor... "
 if [ ! -e /etc/swap.conf ]; then
   echo ENABLE_SWAPPING=yes > /etc/swap.conf
 fi
 . /etc/swap.conf
 if [ $ENABLE_SWAPPING = yes ]; then
   SWAP=$(busybox fdisk -l /dev/sda | grep "Linux swap"| head -n 1| cut -c 6,7,8,9,10) 2>null
   FSTAB_SWAP="# No existe particion swap."
   if [ -b /dev/$SWAP ]; then
     ln -sf $SWAP swap
     FSTAB_SWAP="/dev/$SWAP swap swap default 0 0"
   fi
   echo $FSTAB_SWAP >> /etc/fstab
   swapon -a
 fi
#
#



	# Start all scripts in /etc/rc.scripts.
	echo -e "$amarillo ejecutando scripts  en $azul /etc/rc.scripts $rescolor... "
	for i in /etc/rc.scripts/*
	do
		if [ -x $i ]; then
			$i >/dev/null 2>&1
			status

		fi
	done

	# Start all daemons with scripts in /etc/rc.d.
	echo -e "$amarillo Inicializando demonios en $azul /etc/rc.d... $rescolor "
	for i in /etc/rc.d/*
	do
		if [ -x $i ]; then
			$i start >/dev/null 2>&1
			status
		fi
	done

  	'''  >$WORK_PATH_COMPILER_ROOTFS/etc/init.d/rcS
    	chmod +x $WORK_PATH_COMPILER_ROOTFS/etc/init.d/rcS
    	sleep 0.5
         echo -e "$amarillo Fichero: rcS Demonio \e[1;32mOK!"$rescolor""
else
	echo -e "\e[1;31mFichero:  rcS Demonio  ya existe "$rescolor""
	sleep 0.025
fi

}

FicheroSistemas
#comprimimos el sistema raiz
function compiler {
  cd $WORK_PATH_COMPILER_ROOTFS
 find  . -print | cpio -o -H newc 2>/dev/null | gzip -9 > ../rootfs.gz 2>/dev/null &
 echo -e "$amarillo compresion de rootfs  \e[1;32mOK!"$rescolor""
 sleep 0.5
 cd  $WORK_PATH_ACTUAL
 clear
}
compiler




#funcion que contendra la crecion de los directorios para sistema de arranque
#copiaremos el kernel al directorio boot y rootfs tambien a boot
#configuracion de isolinux
echo -e "$verde############################################################"$rescolor
	echo -e "$verde#            ${rojo}C${amarillo}REANDO ${rojo}D${amarillo}IRECTORIO ${rojo}l${amarillo}IVE   ${verde}                    #" $rescolor                 #"
	echo -e "$verde############################################################"$rescolor
function CreateDirectorioLive {
	if [ ! -d $WORK_PATH_COMPILER/live ]; then
		for work in live  live/boot/ live/boot/isolinux
		do
		mkdir -p $WORK_PATH_COMPILER/$work
		echo -e "$amarillo Directorio: $work \e[1;32mOK!"$rescolor""
		sleep 0.5
		done
		cp kernel/bzImage $WORK_PATH_COMPILER/live/boot/
		echo -e "$amarillo Copiando Kernel  \e[1;32mOK!"$rescolor""
		sleep 0.5
		cp $WORK_PATH_COMPILER/rootfs.gz  $WORK_PATH_COMPILER/live/boot/
		echo -e "$amarillo Copiando rootfs  \e[1;32mOK!"$rescolor""
		sleep 0.5
		cp ficheros/isolinux.bin  $WORK_PATH_COMPILER/live/boot/isolinux
        echo -e "$amarillo Copiando ficheros syslinux \e[1;32mOK!"$rescolor""
        sleep 0.5

		#configuramos el sistema de arranque .cfg
        echo """
        # nano livecd/boot/isolinux/isolinux.cfg
        display display.txt
        default sasagaOS
        label sasagaOS
        kernel /boot/bzImage
        append initrd=/boot/rootfs.gz rw root=/dev/null vga=788
        implicit 0
        prompt 1
        timeout 20
        """ > $WORK_PATH_COMPILER/live/boot/isolinux/isolinux.cfg
        echo -e "$amarillo Fichero: isolinux.cfg \e[1;32mOK!"$rescolor""
        sleep 0.5

        #copiando archivo inicial display.txt para el inico del boot
        cp ficheros/display.txt  $WORK_PATH_COMPILER/live/boot/isolinux/
        echo -e "$amarillo Fichero: display.txt \e[1;32mOK!"$rescolor""
        sleep 0.5

		else
		echo -e "\e[1;31mFichero:  $work  ya existe "$rescolor""
		sleep 0.025
fi


}
CreateDirectorioLive


echo -e "$verde############################################################"$rescolor
echo -e "$verde#                    ${rojo}I${amarillo}MAGEN ${rojo}G${amarillo}ENERADA   ${verde}                    #"$rescolor""
echo -e "$verde############################################################"$rescolor

function GenerarISO {
	cd $WORK_PATH_COMPILER
	genisoimage -R -o sasagaOS.iso -b boot/isolinux/isolinux.bin \
    -c boot/isolinux/boot.cat -no-emul-boot -boot-load-size 4 \
    -V "sasagaOS" -input-charset iso8859-1 -boot-info-table live 2>/dev/null &
    sleep 2
    cp sasagaOS.iso $WORK_PATH_ACTUAL


}
GenerarISO

function verificarISO {
	if [ ! -f $WORK_PATH_ACTUAL/sasagaOS.iso ]; then
		echo -e "\e[1;31mError la imagen no se genero"$rescolor""
		exitmode
	fi
	echo -e "$amarillo Fichero: sasagaOS.iso generada correctamente \e[1;32mOK!"$rescolor""
	echo -e ""
	echo -e "$azul Procederemos a limpiar los temporales \e[1;32mOK!"$rescolor""
	sleep 1

	exitmode

}

verificarISO
