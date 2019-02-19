FROM openjdk:8-jdk-alpine

ARG SUID=1042
ARG SGID=1042

ENV SNOWSTORM_VERSION 2.1.0
ENV SNOWSTORM_DOWNLOAD https://github.com/IHTSDO/snowstorm/releases/download/

RUN mkdir -p /opt/snowstorm/data

WORKDIR /opt/snowstorm

# copy release version and config
RUN wget -O snowstorm.jar $SNOWSTORM_DOWNLOAD$SNOWSTORM_VERSION/snowstorm-$SNOWSTORM_VERSION.jar

# configure run.sh
COPY run.sh .
RUN chmod +x run.sh

# Create the snowstorm user
RUN addgroup -g $SGID snowstorm && \
    adduser -D -u $SUID -G snowstorm snowstorm

# Change permissions.
RUN chown -R snowstorm:snowstorm .

# Run as the snowstorm user.
USER snowstorm

EXPOSE 8080
ENTRYPOINT ["./run.sh"]
CMD ["--snowstorm.rest-api.readonly=true"]
