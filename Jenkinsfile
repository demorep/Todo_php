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
                sh "rm -rf ${WORKSPACE}/app_art/* && mkdir -p ${WORKSPACE}/artifacts/app"
                sh "docker container create --name todoapp_artifact todoapp:1.0"
                sh "docker container cp todoapp_artifact:/var/www/ ${WORKSPACE}/artifacts/app"
                sh "docker container rm -f todoapp_artifact"
                sh "tar -cvzf ${WORKSPACE}/artifacts/app/app-bundle.tar.gz . -C ${WORKSPACE}/artifacts/app/www"
            }
        }
    }
}
