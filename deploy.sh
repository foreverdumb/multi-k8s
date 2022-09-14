docker build -t home1docker1/multi-client-k8s:latest -t home1docker1/multi-client-k8s:$SHA -f ./client/Dockerfile ./client
docker build -t home1docker1/multi-server-k8s-pgfix:latest -t home1docker1/multi-server-k8s-pgfix:$SHA -f ./server/Dockerfile ./server
docker build -t home1docker1/multi-worker-k8s:latest -t home1docker1/multi-worker-k8s:$SHA -f ./worker/Dockerfile ./worker

docker push home1docker1/multi-client-k8s:latest
docker push home1docker1/multi-server-k8s-pgfix:latest
docker push home1docker1/multi-worker-k8s:latest

docker push home1docker1/multi-client-k8s:$SHA
docker push home1docker1/multi-server-k8s-pgfix:$SHA
docker push home1docker1/multi-worker-k8s:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=home1docker1/multi-server-k8s-pgfix:$SHA
kubectl set image deployments/client-deployment client=home1docker1/multi-client-k8s:$SHA
kubectl set image deployments/worker-deployment worker=home1docker1/multi-worker-k8s:$SHA