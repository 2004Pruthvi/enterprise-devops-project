FROM eclipse-temurin:21-jre

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

WORKDIR /app

COPY target/*.jar app.jar

EXPOSE 8082

ENTRYPOINT ["java","-jar","app.jar"]
