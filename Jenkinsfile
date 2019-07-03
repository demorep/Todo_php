pipeline {
    agent any

    stages {
        stage('checkout') {
            steps {
                git url: 'https://github.com/demorep/Todo_php.git'
                sh 'git clean -fdx; sleep 4;'
            }
        }
        stage('Build App') {
            steps {
                sh "docker build --target install -t todo_app_artifact_image:${BUILD_NUMBER} -f app/Dockerfile ."
            }

        }
        stage('Extract Artifact') {
            steps {
                sh "rm -rf ${WORKSPACE}/app_art/* && mkdir -p ${WORKSPACE}/artifacts/app ${WORKSPACE}/artifacts/web"
                sh "docker container create --name todoapp_artifact todo_app_artifact_image:${BUILD_NUMBER}"
                sh "docker container cp todoapp_artifact:/var/www/ ${WORKSPACE}/artifacts/app"
                sh "docker container rm -f todoapp_artifact"
                sh "cp -rap ${WORKSPACE}/app/dependencies-install.sh ${WORKSPACE}/artifacts/app/www/"
                sh "tar -cvzf ${WORKSPACE}/artifacts/app/app-bundle.tar.gz . -C ${WORKSPACE}/artifacts/app/www"
                sh "cp -r ${WORKSPACE}/src ${WORKSPACE}/artifacts/web/ && cp -r ${WORKSPACE}/web/vhost.conf.tpl ${WORKSPACE}/artifacts/web/src/"
                sh "tar -cvzf ${WORKSPACE}/artifacts/web/web-bundle.tar.gz . -C ${WORKSPACE}/artifacts/web/src"
                sh "mkdir -p /tmp/hyperion-artifacts/app/${BUILD_NUMBER}/ /tmp/hyperion-artifacts/web/${BUILD_NUMBER}/ && cp ${WORKSPACE}/artifacts/app/app-bundle.tar.gz /tmp/hyperion-artifacts/app/${BUILD_NUMBER}/ && cp ${WORKSPACE}/artifacts/web/web-bundle.tar.gz /tmp/hyperion-artifacts/web/${BUILD_NUMBER}/"
                sh "sed -i 's/@@BUILD_NUMBER@@/${BUILD_NUMBER}/g' ${WORKSPACE}/app/hyscale/*-props.yaml ${WORKSPACE}/web/hyscale/*-props.yaml"
                
            }
        }
    }
}
