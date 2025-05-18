FROM openjdk:11-jre-slim
COPY target/java-app-1.0.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
