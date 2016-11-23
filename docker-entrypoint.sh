#!/bin/bash
set -e

if [[ -d /docker-entrypoint.d ]] ; then
	for file in /docker-entrypoint.d/*.sh
	do
		echo "docker-entrypoint.sh : Sourcing $file"
		[[ -f $file ]] && . $file
	done
fi

if [[ -d /docker-entrypoint-ext.d ]] ; then
	for file in /docker-entrypoint-ext.d/*.sh
	do
		echo "docker-entrypoint.sh : Sourcing Ext $file"
		[[ -f $file ]] && . $file
	done
fi

exec "$@"

