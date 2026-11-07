FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app

# Instala o Maven oficial no container para garantir que o comando 'mvn' exista
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Copia os arquivos do projeto Spring Boot do diretório correto
COPY taranis-finance-ai/ .

# Roda o build do Maven limpo e sem testes
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8000
ENTRYPOINT ["java", "-jar", "app.jar"]