# Running snowstorm server on your computer
## Pre-requisites:
* Enough disk space at ./elastic/data to hold ElasticSearch indexes 3GB or more
* docker engine with 4GB RAM or more

## Instructions:

* Build docker image locally
```
docker-compose build
```
* Create default docker networks
```
docker network create snowstorm
```
* Run ElasticSearch
```
docker-compose up -d es
```
* Load data into elastic search, change snomedct_rf2_file.zip file name accordingly to your release distribution file name, wait process to finish and then pulse ctrl+c to stop container.
```
docker run --rm -it --net snowstorm -v ~/snomedct_rf2_file.zip:/opt/snowstorm/data/snomedct_rf2_file.zip -e ELASTICSEARCH_URLS=http://es:9200 gpalli/snowstorm --delete-indices --import=/opt/snowstorm/data/snomedct_rf2_file.zip
```

* Start snowstorm api server
```
docker-compose up -d snowstorm
```
* Browse snowstorm api
```
open http://localhost:8080
```
* Stop infraestructure
```
docker-compose down
```
* Remove custom networks
```
docker network rm snowstorm
```

# Running snowstorm on AWS cloud with Kubernetes and Elasticsearch

## Pre-requisites:

* AWS service account
* AWS CLI installed and configured
* Kubernete cluster instaled on AWS (kops or EKS)
* Install and configure kubectl

## Instructions: run these commands from k8s directory

1) Create ElasticSearch on AWS services and get the URL

2) Create Kubernetes cluster use Kops or EKS on AWS

3) Deploy your snomedct rf2 file to and S3 bucket, replace  snomedct_rf2_file.zip with your release distribution file name.

```
aws s3 cp snomedct_rf2_file.zip s3://<bucket_name>
```

4) Generate presigned url of your snomedct rf2 files from S3, expires by default in 1 hour.

```
aws s3 presign s3://<bucket_name>/snomedct_rf2_file.zip
```

5) Create configMap to store environment variables

```
kubectl create configmap snowstorm-config \
  --from-literal=ELASTICSEARCH_URLS=<url_elasticsearch_service_aws_step_1> \
  --from-literal=S3_PRESIGN_SNOMEDCT_RF2_FILE=<presigned_url_from_step_4>
```

6) Load SnomedCT data to ElasticSearch using presigned url of the S3 bucket_name, wait until job finishes.

```
kubectl create -f job-load-snowstorm.yaml
```

7) Deploy container and expose services

```
kubectl create -f app.yaml -f service.yaml
```

```
kubectl apply -f service.yaml
```

8) Browse snowstorm api

```
open http://<your_load_balance_kubernete_endpoint_service_snowstorm>
```
