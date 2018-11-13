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

# APP: Elixir/Phoenix Backend server
docker build ../app -t sense_app:latest

docker tag sense_app:latest eu.gcr.io/${PROJECT_ID}/sense_app:$TAG
docker tag sense_app:latest eu.gcr.io/${PROJECT_ID}/sense_app:latest

docker push eu.gcr.io/${PROJECT_ID}/sense_app:$TAG
docker push eu.gcr.io/${PROJECT_ID}/sense_app:latest

# Deploy
envsubst < kubernetes/app-deployment.yaml | kubectl apply -f -
