cat > src/main/java/com/example/demo/DemoApplication.java <<END
package com.example.demo;

import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.circuitbreaker.EnableCircuitBreaker;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.stream.Collectors;

@EnableDiscoveryClient
@EnableCircuitBreaker
@Configuration
@EnableAutoConfiguration
@RestController
@SpringBootApplication
public class DemoApplication {

    @Autowired
    private DiscoveryClient discoveryClient;

    @Value("\${spring.application.name}")
    String applicationName;

    @RequestMapping("/")
    public String home() {
        return applicationName + ": " + instanceNames();
    }

    @HystrixCommand(fallbackMethod = "fallbackInstanceNames")
    private String instanceNames() {
        return this.discoveryClient.getInstances(applicationName).stream().map(ServiceInstance::getHost).collect(Collectors.joining(", "));
    }

    private String fallbackInstanceNames() {
        return "no hosts found";
    }

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}
END

cat > src/main/resources/application.properties <<EOF
management.security.enabled=false
security.basic.enabled=false
EOF

read  -n 1 -p "Continue: " mainmenuinput

mvn clean package

cf push cna-demo -p target/demo-0.0.1-SNAPSHOT.jar --no-start
cf bind-service cna-demo service-registry
cf start cna-demo
