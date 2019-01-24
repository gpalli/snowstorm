FROM openjdk:8-jdk-alpine

RUN mkdir -p /opt/snowstorm
RUN mkdir -p /opt/snowstorm/config

WORKDIR /opt/snowstorm
VOLUME /tmp

RUN wget https://github.com/IHTSDO/snowstorm/releases/download/2.1.0/snowstorm-2.1.0.jar

EXPOSE 8080

# Descomentar para subir la base de datos para la importacion como explica en load_snowstorm.txt
#COPY SnomedCT_Argentina-EditionRelease_PRODUCTION_20181130T120000Z.zip /tmp

COPY config /opt/snowstorm/config

CMD ["java","-jar","snowstorm-2.1.0.jar"]
