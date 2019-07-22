pipeline {
    agent any

    stages {
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
                sh "tar -czf ${WORKSPACE}/artifacts/app/app-bundle.tar.gz . -C ${WORKSPACE}/artifacts/app/www"
                sh "cp -r ${WORKSPACE}/src ${WORKSPACE}/artifacts/web/ && cp -r ${WORKSPACE}/web/vhost.conf.tpl ${WORKSPACE}/artifacts/web/src/"
                sh "tar -czf ${WORKSPACE}/artifacts/web/web-bundle.tar.gz . -C ${WORKSPACE}/artifacts/web/src"
                sh "sed -i 's/@@BUILD_NUMBER@@/${BUILD_NUMBER}/g' ${WORKSPACE}/config/*-props.yaml"
                
            }
        }
        stage('Publish Artifact') {
            steps {
                 sh "mkdir -p /artifactory_home/hyperion-artifacts/app/${BUILD_NUMBER}/ /artifactory_home/hyperion-artifacts/web/${BUILD_NUMBER}/ && cp ${WORKSPACE}/artifacts/app/app-bundle.tar.gz /artifactory_home/hyperion-artifacts/app/${BUILD_NUMBER}/ && cp ${WORKSPACE}/artifacts/web/web-bundle.tar.gz /artifactory_home/hyperion-artifacts/web/${BUILD_NUMBER}/"
        }
      }
        stage('Image & Deploy-to-Dev') {
            steps {
            echo 'Deploying to Dev...'
            load "$JENKINS_HOME/.envvars/hyslogin.groovy"
            echo "${env.hys_user}"
            echo "${env.hys_pwd}"
            sh "hyscalectl login hyperion.hyscale.io -u${env.hys_user} -p${env.hys_pwd}"
            sh "hyscalectl deploy -s app -e dev -p ${WORKSPACE}/config/dev-props.yaml -a demo-Todo-app"
            sleep(120)
        }
 
      }

        stage('Test-Dev') {
            steps {
            echo 'Running Test on Dev...'
            sleep(80)
        }

      }
        stage('Deploy-to-Stage') {
            input {
                message "Deploy to stage?"
                ok "Yes"
            } 
            steps {
            echo 'Deploying to Stage...'
            sh "source /root/.hyslogin && hyscalectl login hyperion.hyscale.io -u$hys_user -p$hys_pwd"
            sh "hyscalectl deploy -s app -e stage -p ${WORKSPACE}/config/stage-props.yaml -a demo-Todo-app"
            sleep(120)
        }

      }
       stage('Test-Stage') {
            steps {
            echo 'Running Test on Stage...'
            sleep(80)
        }

      }
       stage('Deploy-to-Prod') {
            input {
                message "Deploy to prod?"
                ok "Yes"   
            }
            steps {
            echo 'Deploying to Prod...'
            sh "source /root/.hyslogin && hyscalectl login hyperion.hyscale.io -u$hys_user -p$hys_pwd"
            sh "hyscalectl deploy -s app -e prod -p ${WORKSPACE}/config/prod-props.yaml -a demo-Todo-app"
            sleep(120)
        }

      }
       stage('Test-Prod') {
            steps {
            echo 'Running Test on Prod...'
            sleep(80)
        }

      }   

    }
}
