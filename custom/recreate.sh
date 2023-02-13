#!/bin/bash
# usage: ./recreate.sh datahub-actions

CONTAINER=$1

if [ -z $CONTAINER ]; then
	echo "please specific CONTAINER your want to recreate"
	exit 1
fi

docker-compose -p datahub stop $CONTAINER
docker-compose -p datahub rm  -f $CONTAINER
docker-compose -p datahub up -d $CONTAINER

datahub docker check

