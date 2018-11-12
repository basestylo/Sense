if [ -z "$1" ]
then
    echo "No argument supplied"
    export TAG=$(git rev-parse HEAD)
    echo "Using git commit reference $TAG"
else
    export TAG=$1
    echo "Using tag $TAG"
fi

./deploy-web.sh $TAG
./deploy-app.sh $TAG
./deploy-mqtt.sh $TAG
