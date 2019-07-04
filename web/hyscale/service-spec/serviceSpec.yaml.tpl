kind: ServiceSpec
apiVersion: hyscale.io/v1/
metadata:
  name: web
  version: 1
  replicas: "{{ REPLICAS | default('1') }}"
  resourceLimits:
    memory: "{{ MEMORY_LIMIT_IN_MB | default('512') }}"
  dependencies:
  - app
  deployProps:
  - key: BUILD_NUMBER
    value: "{{ BUILD_NUMBER | default ('100') }}"
spec:
  external: 
  - nginx-port
  stack:
    name: nginx
    version: 1.10
    docker-registry: "dockerhublibrary"
    importImage: nginx:1.10
    ports:
    - name: nginx-port
      type: TCP
      port: 80
      default: 80 # why
    os: Ubuntu:14.04 # To be removed
    distribution: DEBIAN # why

  artifacts:
  - name: todo_web_artifact_bundle
    destination: "/tmp/"
    source:
      store: Jenkins
      basedir: "/home/ubuntu/artifactory_home/hyperion-artifacts/web/${BUILD_NUMBER}/"
      path: "web-bundle.tar.gz"
  config:
    commands: |-
       mkdir -p /var/www
       tar -xvzf /tmp/web-bundle.tar.gz -C /var/www/
       sed -i  "s/{{ '{{' }} APP_HOSTNAME {{ '}}' }}/$APP_HOST/g" /var/www/vhost.conf.tpl
       sed -i  "s/{{ '{{' }} APP_PORT {{ '}}' }}/$APP_PORT/g" /var/www/vhost.conf.tpl
       mv /var/www/vhost.conf.tpl /etc/nginx/conf.d/default.conf
       
    props:
    - key: APP_HOST
      type: ENDPOINT
      value: "app"
    - key: APP_PORT
      value: 9000
