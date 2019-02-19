#!/bin/sh
echo $@
java -Xms2g -Xmx2g -jar snowstorm.jar --elasticsearch.urls=$ELASTICSEARCH_URLS $@
