cat > src/main/java/com/example/demo/DemoApplication.java <<END
package com.example.demo;

import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.circuitbreaker.EnableCircuitBreaker;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@EnableCircuitBreaker
@Configuration
@EnableAutoConfiguration
@RestController
@SpringBootApplication
public class DemoApplication {

	@Value("\${config.name}")
	String name = "World";

    @HystrixCommand(fallbackMethod = "reliable")
    @RequestMapping("/")
	public String home() {
		return risky();
	}

	private String risky() {
        if (Math.random() <= 0.5) {
            throw new RuntimeException("BOOM");
        };
        return "Risky " + name;
    }

    private String reliable() {
        return "Reliable " + name;
    }

    public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}
}
END

mvn clean package

cf push cna-demo -p target/demo-0.0.1-SNAPSHOT.jar --no-start
cf bind-service cna-demo circuit-breaker-dashboard
cf start cna-demo
