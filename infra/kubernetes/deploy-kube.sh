kubectl create namespace senseapp || true

kubectl apply -f postgres-claim0-persistentvolumeclaim.yaml,postgres-deployment.yaml,postgres-service.yaml

kubectl apply -f influxdb-claim0-persistentvolumeclaim.yaml,influxdb-deployment.yaml,influxdb-service.yaml

kubectl apply -f mqtt-deployment.yaml,mqtt-service.yaml

kubectl apply -f web-deployment.yaml,web-service.yaml,web-ingress.yaml

kubectl apply -f app-deployment.yaml,app-service.yaml,app-ingress.yaml
