# Etap 1: Budowanie aplikacji
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

# Skopiuj plik pom.xml i pobierz zależności
COPY pom.xml .
RUN mvn -q dependency:go-offline

# Skopiuj cały projekt i zbuduj go
COPY src ./src
RUN mvn -q clean package -DskipTests

# Etap 2: Uruchomienie aplikacji
FROM eclipse-temurin:17-jre
WORKDIR /app

# Skopiuj zbudowany JAR z poprzedniego etapu
COPY --from=build /app/target/*.jar app.jar

# Otwórz port aplikacji (domyślnie Spring Boot używa 8080)
EXPOSE 8080

# Uruchom aplikację
ENTRYPOINT ["java", "-jar", "app.jar"]
