FROM openjdk:8-jdk-alpine

RUN mkdir -p /opt/snowstorm
RUN mkdir -p /opt/snowstorm/config

WORKDIR /opt/snowstorm
VOLUME /tmp

EXPOSE 8080

ADD snowstorm-2.1.0.jar snowstorm-2.1.0.jar

# Descomentar para subir la base de datos para la importacion como explica en load_snowstorm.txt
#COPY SnomedCT_Argentina-EditionRelease_PRODUCTION_20181130T120000Z.zip /tmp

COPY config /opt/snowstorm/config

CMD ["java","-jar","snowstorm-2.1.0.jar"]
