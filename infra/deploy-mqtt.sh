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

# Deploy
envsubst < kubernetes/mqtt-deployment.yaml | kubectl apply -f -
