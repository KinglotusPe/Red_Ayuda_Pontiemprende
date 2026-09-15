# Multi-stage build for Spring Boot Java 21
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /workspace/app

# Copy Maven wrapper & pom
COPY backend/.mvn .mvn
COPY backend/mvnw backend/mvnw.cmd backend/pom.xml ./
RUN chmod +x ./mvnw

# Download dependencies (cache layer)
RUN ./mvnw dependency:go-offline -B

# Copy sources and compile package
COPY backend/src ./src
RUN ./mvnw clean package -DskipTests -B

# Runtime image
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

COPY --from=builder /workspace/app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.jar"]
