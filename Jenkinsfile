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
                sh "docker build --target install -t todoapp:1.0 -f app/Dockerfile ."
            }

        }
        stage('Extract Artifact') {
            steps {
                sh "rm -rf ${WORKSPACE}/app_art/* && mkdir ${WORKSPACE}/app_art"
                sh "docker container create --name extract todoapp:1.0"
                sh "docker container cp extract:/var/www/ ${WORKSPACE}/app_art/"
                sh "docker container rm -f extract"
                sh "tar -cf ${WORKSPACE}/app_art/todoapp.tar www -C ${WORKSPACE}/app_art/"
            }
        }
    }
}
