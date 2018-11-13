if [ -z "$1" ]
then
    echo "No argument supplied"
    export TAG=$(git rev-parse HEAD)
    echo "Using git commit reference $TAG"
else
    export TAG=$1
    echo "Using tag $TAG"
fi

gcloud auth configure-docker --quiet

export PROJECT_ID="$(gcloud config get-value project -q)"

# APP: Angular Frontend app
docker build ../web -t sense_web:latest --target prod-image

docker tag sense_web:latest eu.gcr.io/${PROJECT_ID}/sense_web:$TAG
docker tag sense_web:latest eu.gcr.io/${PROJECT_ID}/sense_web:latest

docker push eu.gcr.io/${PROJECT_ID}/sense_web:$TAG
docker push eu.gcr.io/${PROJECT_ID}/sense_web:latest

# Deploy
envsubst < kubernetes/web-deployment.yaml | kubectl apply -f -
