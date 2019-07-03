kind: ServiceSpec
apiVersion: hyscale.io/v1/
metadata:
  name: app
  version: 1
  replicas: "{{ REPLICAS | default('1') }}"
  resourceLimits:
    memory: "{{ MEMORY_LIMIT_IN_MB | default('512') }}"
  dependencies:
  - database
  healthChecks:
  - port: 9000
    healthCheckType: HTTP
    httpPath: "/index.php"
  deployProps:
  - key: BUILD_NUMBER
    value: "{{ BUILD_NUMBER | default ('100') }}"
spec:
  stack:
    name: php
    version: 7-fpm
    docker-registry: {{ DOCKER_REGISTRY_NAME | default('dockerhub') }} # make sure helpers is in place
    importImage: postgres:9.3
    ports:
    - name: php-fpm-port
      type: TCP
      port: 9000
      default: 9000 # why
    os: Ubuntu:14.04 # To be removed
    distribution: DEBIAN # why

  artifacts:
  - name: todo_app_artifact_bundle
    destination: "/tmp/"
    source:
      store: {{ JENKINS_ARTIFACTORY_NAME | default('Jenkins') }} # helpers
      basedir: "/tmp/hyperion-artifacts/app/${BUILD_NUMBER}"
      path: "hyperion-app-artifact.tar.gz"
  config:
    commands: |-
       tar -xvzf /tmp/hyperion-app-artifact.tar.gz -C /var/www/
       echo "Installing Dependencies for app to run..."
       bash -x /var/www/dependencies-install.sh
       echo "Dependencies installed !"
       echo "Migrated Databases..."
       php artisan migrate:refresh
       echo "Database Successfully Migrated !"
       
    props:
    - key: DB_PORT
      value: "3306"
    - key: DB_HOST
      type: ENDPOINT
      value: "database"
