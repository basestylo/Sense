if [ -z "$1" ]
then
    echo "No argument supplied"
    export TAG=$(git rev-parse HEAD)
    echo "Using git commit reference $TAG"
else
    export TAG=$1
    echo "Using tag $TAG"
fi

set -e

gcloud auth configure-docker --quiet

export PROJECT_ID="$(gcloud config get-value project -q)"

# DB: Mosquitto custom with auth schema
docker build ./mqtt -t sense_mqtt:latest

docker tag sense_mqtt:latest eu.gcr.io/${PROJECT_ID}/sense_mqtt:$TAG
docker tag sense_mqtt:latest eu.gcr.io/${PROJECT_ID}/sense_mqtt:latest

docker push eu.gcr.io/${PROJECT_ID}/sense_mqtt:$TAG
docker push eu.gcr.io/${PROJECT_ID}/sense_mqtt:latest

# Deploy
envsubst < kubernetes/mqtt-deployment.yaml | kubectl apply -f -
