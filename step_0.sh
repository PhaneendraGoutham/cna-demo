# Use Spring Start
#- Config Client PCF
#- Circuit Breaker PCF
#- Service Registry PCF
#- Cloud Bus AMQP
#- Actuator

# extract to workspace
#cf login

echo "{\"git\": {\"uri\": \"https://github.com/micahyoung/cna-demo-config.git\"}}" > cloud-config-uri.json

cf create-service p-rabbitmq standard cloud-bus
cf create-service p-config-server standard config-server -c cloud-config-uri.json
cf create-service p-circuit-breaker-dashboard standard circuit-breaker-dashboard
cf create-service p-service-registry standard service-registry
