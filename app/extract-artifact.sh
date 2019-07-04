#!/bin/bash

app_artifact_image=${1:-"vijaysamanuri/todo_app_install:1.0"}
build_number=${2}

if [ -z $build_number ]; then
	if [ -z "$BUILD_NUMBER" ]; then
		echo "BUILD_NUMBER not passed"
		exit 1
	fi
	build_number="$BUILD_NUMBER"
fi

# create temporary container
docker run --name=todo-app-artifact-image --entrypoint "" $app_artifact_image sleep 1

todo_artifacts_dir="/tmp/todo-artifacts/"
TMP_DIR=$(mktemp -d)

docker cp todo-app-artifact-image:/var/www $TMP_DIR/
pushd $TMP_DIR/www
tar -cvzf $todo_artifacts_dir/app/${BUILD_NUMBER}/app-bundle.tar.gz *
popd

rm -rf $TMP_DIR
docker rm todo-app-artifact-image
