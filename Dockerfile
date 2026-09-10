# ============================================================
# Stage 1: Build the Spring Boot application
# ============================================================
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml first (Docker caches this layer)
COPY pom.xml .

# Download dependencies (cached unless pom.xml changes)
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the JAR
RUN mvn clean package -DskipTests

# ============================================================
# Stage 2: Runtime image
# ============================================================
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy the built JAR from the previous stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port the app runs on
EXPOSE 2002

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:2002/actuator/health || exit 1

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
