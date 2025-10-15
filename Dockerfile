# 1) Build stage
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
# pre-fetch deps for faster rebuilds
RUN mvn -q -e -U -DskipTests dependency:go-offline
COPY src ./src
RUN mvn -q -DskipTests package

# 2) Runtime stage
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
# copy the built jar (adjust artifact name if needed)
COPY --from=builder /app/target/student-management-0.0.1-SNAPSHOT.jar app.jar
# run as non-root
RUN adduser -D appuser
USER appuser
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
