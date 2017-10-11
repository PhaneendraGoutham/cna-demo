curl -L 'https://search.maven.org/remote_content?g=io.zipkin.java&a=zipkin-server&v=LATEST&c=exec' > zipkin.jar
cf push cna-zipkin-server -p ./zipkin.jar --no-start

cf bind-service cna-zipkin-server service-registry

cf start cna-zipkin-server
