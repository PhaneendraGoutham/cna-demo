
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

	@Value("\${config.greeting}")
	String greeting;

	@RequestMapping("/")
	public String home() {
		return "Hello " + greeting;
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
config.greeting=World
EOF

read  -n 1 -p "Continue: " mainmenuinput

mvn clean package

cf push cna-demo -p target/demo-0.0.1-SNAPSHOT.jar --no-start
cf bind-service  cna-demo cloud-bus
cf bind-service  cna-demo config-server
cf start cna-demo
