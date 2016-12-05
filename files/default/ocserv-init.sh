#!/bin/sh
#
# ocserv        This shell script takes care of starting and stopping
#               ocserv on RedHat or other chkconfig-based system.
#
# chkconfig: - 24 76
#
# processname: ocserv
#              port.

### BEGIN INIT INFO
# Provides: ocserv
# Required-Start: $network
# Required-Stop: $network
# Short-Description: start and stop ocserv
# Description: ocserv is a VPN server
### END INIT INFO


# To install:
#   copy this file to /etc/rc.d/init.d/ocserv
#   shell> chkconfig --add ocserv
#   shell> mkdir /etc/ocserv
#   make .conf or .sh files in /etc/ocserv (see below)

# To uninstall:
#   run: chkconfig --del ocserv

ocserv=""
ocserv_locations="/usr/sbin/ocserv /usr/local/sbin/ocserv"
for location in $ocserv_locations
do
  if [ -f "$location" ]
  then
    ocserv=$location
  fi
done

# PID directory
piddir="/var/run/ocserv"
pidf="$piddir/ocserv.pid"

# Our working directory
work=/etc/ocserv

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
if [ ${NETWORKING} = "no" ]
then
  echo "Networking is down"
  exit 0
fi

# Check that binary exists
if ! [ -f  $ocserv ] 
then
  echo "ocserv binary not found"
  exit 0
fi

# See how we were called.
case "$1" in
  start)
	echo -n $"Starting ocserv: "

	/sbin/modprobe tun >/dev/null 2>&1

	# From a security perspective, I think it makes
	# sense to remove this, and have users who need
	# it explictly enable in their --up scripts or
	# firewall setups.

	#echo 1 > /proc/sys/net/ipv4/ip_forward

	# Run startup script, if defined
	if [ -x /usr/sbin/ocserv-genkey ]; then
	    /usr/sbin/ocserv-genkey
	fi

	if [ ! -d  $piddir ]; then
	    mkdir $piddir
	fi

	if [ -s $pidf ]; then
		kill `cat $pidf` >/dev/null 2>&1
		sleep 2
	fi
	rm -f $pidf

	cd $work

	# Start every .conf in $work and run .sh if exists
	errors=0
	$ocserv --pid-file $pidf -c $work/ocserv.conf
	errors=$?
	if [ $errors != 0 ]; then
	    failure; echo
	else
	    success; echo
	fi
	;;
  stop)
	echo -n $"Shutting down ocserv: "
	if [ -s $pidf ]; then
		kill `cat $pidf` >/dev/null 2>&1
	fi
	rm -f $pidf

	success; echo
	rm -f $lock
	;;
  restart)
	$0 stop
	sleep 2
	$0 start
	;;
  reload)
        if [ -e /var/run/occtl.socket ]; then
	  /usr/bin/occtl reload
	  exit $?
        else
          exit 1
        fi
	;;
  reopen)
	;;
  condrestart)
	$0 stop
	sleep 2
	$0 start
	;;
  status)
        if [ -e /var/run/occtl.socket ]; then
	  /usr/bin/occtl show status
        else
          echo "OpenConnect SSL VPN is not running."
          exit 3
        fi
        ;;
  *)
	echo "Usage: ocserv {start|stop|restart|condrestart|reload|reopen|status}"
	exit 1
	;;
esac
exit 0
