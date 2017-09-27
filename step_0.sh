# Use Spring Start
#- Config Client PCF
#- Circuit Breaker PCF
#- Service Registry PCF
#- Cloud Bus AMQP
#- Actuator

# extract to workspace
cf login

cf create-service cloudamqp lemur cloud-bus
cf create-service p-config-server standard config-server -c cloud-config-uri.json
cf create-service p-circuit-breaker-dashboard standard circuit-breaker-dashboard
cf create-service p-service-registry standard service-registry