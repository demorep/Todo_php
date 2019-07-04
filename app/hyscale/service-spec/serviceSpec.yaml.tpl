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
  deployProps:
  - key: BUILD_NUMBER
    value: "{{ BUILD_NUMBER | default ('100') }}"
spec:
  stack:
    name: phpnew
    version: 7-fpm
    docker-registry: dockerhub1
    importImage: php:7-fpm
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
      store: "jenkins"
      basedir: "/tmp/hyperion-artifacts/app/${BUILD_NUMBER}"
      path: "hyperion-app-artifact.tar.gz"
  config:
    commands: |-
       tar -xvzf /tmp/hyperion-app-artifact.tar.gz -C /var/www/
       chmod -R 777 /var/www/storage
       echo "Installing Dependencies for app to run..."
       bash -x /var/www/dependencies-install.sh
       echo "Dependencies installed !"
       echo "Migrating Databases..."
       cd /var/www/
       php artisan migrate:refresh
       echo "Database Successfully Migrated !"
       
    props:
    - key: DB_PORT
      value: "3306"
    - key: DB_HOST
      type: ENDPOINT
      value: "database"
    - key: DB_USERNAME
      value: "root"
    - key: DB_DATABASE
      value: "dockerApp"
    - key: DB_PASSWORD
      type: PASSWORD
      value: {{ DB_PASSWORD | default('secret') }}
    - key: DB_CONNECTION
      value: "mysql"
    - key: APP_DEBUG
      value: {{ APP_DEBUG | default('true') }}
    - key: APP_ENV
      value: {{ APP_ENV | default('local') }}
    - key: APP_LOG
      value: {{ APP_LOG | default('daily') }}
    - key: APP_LOG_LEVEL
      value: {{ APP_LOG_LEVEL | default('debug') }}
