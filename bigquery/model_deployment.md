gcloud auth login
bq --project_id taxi-rides-ny extract -m nytaxi.tip_model gs://taxi_ml_model/tip_model
mkdir /tmp/model
gsutil cp -r gs://taxi_ml_model/tip_model /tmp/model
mkdir -p serving_dir/tip_model/1
cp -r /tmp/model/tip_model/* serving_dir/tip_model/1
docker pull tensorflow/serving
docker run -p 8501:8501 --mount type=bind,source=pwd/serving_dir/tip_model,target= /models/tip_model -e MODEL_NAME=tip_model -t tensorflow/serving &
curl -d '{"instances": [{"passenger_count":1, "trip_distance":12.2, "PULocationID":"193", "DOLocationID":"264", "payment_type":"2","fare_amount":20.4,"tolls_amount":0.0}]}' -X POST http://localhost:8501/v1/models/tip_model:predicthttp://localhost:8501/v1/models/tip_model

# My Version
gcloud auth login

# Copying the model from bigquery to gcs bucket
bq --project_id dtc-de-26051982 extract -m terra_demo_bq_dataset.tip_model gs://dtc-de-26051982-terra-bucket/tip_model

# create a tmp directory locally to copy the model from gcs bucket to local
mkdir /tmp/model

# copy the model from gcs to local
gsutil cp -r gs://dtc-de-26051982-terra-bucket/tip_model /tmp/model

# create a source serving folder in the present directory for the model to use it in docker deployment
mkdir -p serving_dir/tip_model/1

# copy the model from tmp to serving folder
cp -r /tmp/model/tip_model/* serving_dir/tip_model/1

# pull tensorflow serving official docker image
docker pull tensorflow/serving

# run below coimmand to run the pulled docker image sopecifying port, mounting type,source and target

# there should not be any space between the type, source and target strings
# order of the mount, e and t matters
docker run -p 8501:8501 --mount \
type=bind,source=`pwd`/serving_dir/tip_model,target=/models/tip_model \
-e MODEL_NAME=tip_model \
-t tensorflow/serving &

# to check the prediction from the hosted model api

curl -d '{"instances": [{"passenger_count":1, "trip_distance":12.2, "PULocationID":"193", "DOLocationID":"264", "payment_type":"2","fare_amount":20.4,"tolls_amount":0.0}]}' -X POST http://localhost:8501/v1/models/tip_model:predict

# To check the model status:
http://localhost:8501/v1/models/tip_model