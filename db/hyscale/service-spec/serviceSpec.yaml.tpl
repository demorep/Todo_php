kind: ServiceSpec
apiVersion: hyscale.io/v1/
metadata:
  name: database
  version: 1
  replicas: "{{ REPLICAS | default('1') }}"
  resourceLimits:
    memory: "{{ MEMORY_LIMIT_IN_MB | default('512') }}"
  healthChecks:
  - port: 3306
    healthCheckType: TCP
spec:
  stack:
    name: mysql
    version: 5.6
    docker-registry: {{ DOCKER_REGISTRY_NAME | default('dockerhub') }} # make sure helpers is in place
    importImage: mysql:5.6
    ports:
    - name: mysql-port
      type: TCP
      port: 3306
      default: 3306 # why
    os: Ubuntu:14.04 # To be removed
    distribution: DEBIAN # why

  config:
    props:
    - key: MYSQL_ROOT_PASSWORD
      type: PASSWORD
      value: {{ MYSQL_ROOT_PASSWORD | default('secret') }}
    - key: MYSQL_DATABASE
      value: "dockerApp"
