# Backend multi-stage Dockerfile
FROM maven:3.8.8-jdk-17 AS build
WORKDIR /app

# copy wrapper and maven metadata first for better caching
COPY mvnw ./
COPY .mvn .mvn
RUN chmod +x ./mvnw

# copy pom and sources
COPY pom.xml ./
COPY src ./src

# use the wrapper when available; fall back to system mvn inside image
RUN if [ -x ./mvnw ]; then ./mvnw -B -DskipTests package; else mvn -B -DskipTests package; fi

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8089

ENV JAVA_OPTS=""
# use exec so Java gets PID 1 signals correctly
ENTRYPOINT ["sh","-c","exec java $JAVA_OPTS -jar /app/app.jar"]
