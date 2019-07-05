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
        stage('Deploy-to-Dev') {
            steps {
            echo 'Deploying to Dev...'
            sh "hyscalectl login hyperion.hyscale.io -uhyscalecli@hyscale.io -pHysc@l3Cl!"
            sh "hyscalectl  deploy -f ${WORKSPACE}/db/hyscale/service-spec/serviceSpec.yaml.tpl -f ${WORKSPACE}/app/hyscale/service-spec/serviceSpec.yaml.tpl -f ${WORKSPACE}/web/hyscale/service-spec/serviceSpec.yaml.tpl -e dev -p ${WORKSPACE}/config/dev-props.yaml -a demo-Todo-app"
            sh "hyscalectl  track env dev -a demo-Todo-app"
        }
 
      }

        stage('Test-Dev') {
            steps {
            echo 'Running Test on Dev...'
            sleep(180)
        }

      }
        stage('Deploy-to-Stage') {
            input {
                message "Deploy to stage?"
                ok "Yes, we should."   
            }
            steps {
            echo 'Deploying to Stage...'
            sh "hyscalectl login hyperion.hyscale.io -uhyscalecli@hyscale.io -pHysc@l3Cl!"
            sh "hyscalectl  deploy -f ${WORKSPACE}/db/hyscale/service-spec/serviceSpec.yaml.tpl -f ${WORKSPACE}/app/hyscale/service-spec/serviceSpec.yaml.tpl -f ${WORKSPACE}/web/hyscale/service-spec/serviceSpec.yaml.tpl -e stage -p ${WORKSPACE}/config/stage-props.yaml -a demo-Todo-app"
           sh "hyscalectl  track env stage -a demo-Todo-app"
        }

      }
       stage('Test-Stage') {
            steps {
            echo 'Running Test on Stage...'
            sleep(180)
        }

      }
       stage('Deploy-to-Prod') {
            input {
                message "Deploy to prod?"
                ok "Yes, we should."   
            }
            steps {
            echo 'Deploying to Prod...'
            sh "hyscalectl login hyperion.hyscale.io -uhyscalecli@hyscale.io -pHysc@l3Cl!"
            sh "hyscalectl  deploy -f ${WORKSPACE}/db/hyscale/service-spec/serviceSpec.yaml.tpl -f ${WORKSPACE}/app/hyscale/service-spec/serviceSpec.yaml.tpl -f ${WORKSPACE}/web/hyscale/service-spec/serviceSpec.yaml.tpl -e prod -p ${WORKSPACE}/config/prod-props.yaml -a demo-Todo-app"
           sh "hyscalectl track env prod -a demo-Todo-app"
        }

      }
       stage('Test-Prod') {
            steps {
            echo 'Running Test on Prod...'
            sleep(180)
        }

      }   

    }
}
