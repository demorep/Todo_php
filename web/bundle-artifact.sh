#!/bin/bash

build_number=${1}

if [ -z $build_number ]; then
	if [ -z "$BUILD_NUMBER" ]; then
		echo "BUILD_NUMBER not passed"
		exit 1
	fi
	build_number="$BUILD_NUMBER"
fi

# create temporary container

repo="/usr/local/repositories/$build_number/" # should be updated

todo_artifacts_dir="/tmp/todo-artifacts/"
TMP_DIR=$(mktemp -d)

cp -r $repo/src/www/ $TMP_DIR/
cp $repo/web/vhost.conf.tpl $TMP_DIR/www/

pushd $TMP_DIR/www
tar -cvzf $todo_artifacts_dir/web/${BUILD_NUMBER}/web-bundle.tar.gz *
popd


rm -rf $TMP_DIR
docker rm todo-app-artifact-image
