FROM openjdk:8-jdk-alpine

RUN mkdir -p /opt/snowstorm
RUN mkdir -p /opt/snowstorm/config

WORKDIR /opt/snowstorm
VOLUME /tmp

RUN wget https://github.com/IHTSDO/snowstorm/releases/download/2.1.0/snowstorm-2.1.0.jar

EXPOSE 8080

## Descomentar para subir la imagen con los datos para la importacion como necesita el job-load-snowstorm.yaml
#
#COPY SnomedCT_Argentina-EditionRelease_PRODUCTION_20181130T120000Z.zip /tmp

COPY config /opt/snowstorm/config

CMD ["java","-Xms2g","-Xmx2g","-jar","snowstorm-2.1.0.jar","--snowstorm.rest-api.readonly=true"]
