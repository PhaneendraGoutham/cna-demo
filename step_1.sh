# Use Spring Start
#- Config Client PCF
#- Circuit Breaker PCF
#- Service Registry PCF
#- Cloud Bus AMQP
#- Actuator

unzip demo.zip
cd demo

cat > src/main/java/com/example/demo/DemoApplication.java <<END
package com.example.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Configuration
@EnableAutoConfiguration
@RestController
@SpringBootApplication
public class DemoApplication {

	@Value("\${config.name}")
	String name = "World";

	@RequestMapping("/")
	public String home() {
		return "Hello " + name;
	}

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}
}
END

mkdir -p src/main/resources

cat > src/main/resources/application.properties <<EOF
management.security.enabled=false
security.basic.enabled=false
config.name=Foo
EOF

mvn clean package

echo "{\"git\": {\"uri\": \"https://github.com/micahyoung/cna-demo-config.git\"}}" > cloud-config-uri.json
cf create-service p-config-server standard config-server -c cloud-config-uri.json
cf create-service cloudamqp lemur cloud-bus
cf create-service p-service-registry standard service-registry
cf create-service p-circuit-breaker-dashboard standard circuit-breaker-dashboard

cf bind-service  cna-demo cloud-bus
cf bind-service  cna-demo config-server
cf push cna-demo -p target/demo-0.0.1-SNAPSHOT.jar
