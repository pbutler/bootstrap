#!/bin/bash

PIDFILE=/tmp/synergy.pid

case "$1" in
	"start")
		if [ -f $PIDFILE ]; then
			exit 1
		fi
		/Applications/Synergy.app/Contents/MacOS/synergys -n inanna.killertux.org
		sleep .1
		ps -ef | grep synergy | grep -v grep
		pid=`ps -ef | grep synergys | grep -v $$ | grep -v grep | awk '{print \$2}'`

		umask 0066
		echo $pid > $PIDFILE
		;;
	"stop")
		if [ ! -f $PIDFILE ]; then
			exit 1
		fi
		kill -0 `cat $PIDFILE` && kill `cat $PIDFILE`
		rm -f $PIDFILE
	;;
	"restart")
		$0 stop
		sleep 1
		$0 start
	;;

	*)
		echo "start, stop, or restart, no other commands available"
	;;
esac
