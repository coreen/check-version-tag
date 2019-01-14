#!/bin/sh

# Checks if docker image already has package.json version published
# Usage: ./check-version-tag.sh IMAGE_NAME {CURRENT_VERSION}
# CURRENT_VERSION optional, will default to PACKAGE_VERSION if not set

if [ $# -eq 0 ]; then
	echo "bad input, Usage: ./check-version-tag.sh IMAGE_NAME {CURRENT_VERSION}"
	echo "CURRENT_VERSION optional, will default package.json version otherwise"
	exit 1
fi

VERSION=

if [ $# -lt 2 ]; then
	PACKAGE_VERSION=$(cat package.json \
		| grep version \
		| head -1 \
		| awk -F: '{ print $2 }' \
		| sed 's/[",]//g' \
		| tr -d '[[:space:]]')
	VERSION=$PACKAGE_VERSION
else
	CURRENT_VERSION=$2
	VERSION=$CURRENT_VERSION
fi

IMAGE_NAME=$1

TAGS=`wget -q https://registry.hub.docker.com/v1/repositories/${IMAGE_NAME}/tags`

if [[ $TAGS = *"${VERSION}"* ]]; then
	echo "Tag already exists"
	exit 1
fi

exit 0
