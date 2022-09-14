#bin/bash

#Building images for setting up local k8s cluster
echo $PWD
cd ./client; docker build -t home1docker1/multi-client:latest -f Dockerfile .
cd ..; cd ./server; docker build -t home1docker1/multi-server:latest -f Dockerfile . 
cd ..; cd ./worker; docker build -t home1docker1/multi-worker:latest -f Dockerfile .

#Building images for setting up prod k8s cluster
cd..; cd ./client; docker build -t home1docker1/multi-client:$COMMIT_SHA -f Dockerfile .
cd ..; cd ./server; docker build -t home1docker1/multi-server:$COMMIT_SHA -f Dockerfile . 
cd ..; cd ./worker; docker build -t home1docker1/multi-worker:$COMMIT_SHA -f Dockerfile .

#Pushing images(local purposes) 
docker push home1docker1/multi-client:latest
docker push home1docker1/multi-server:latest
docker push home1docker1/multi-worker:latest

#Pushing images(prod purposes)
docker push home1docker1/multi-client:$COMMIT_SHA
docker push home1docker1/multi-server:$COMMIT_SHA
docker push home1docker1/multi-worker:$COMMIT_SHA

#Deploying k8s objects
cd ..; cd ./k8s; kubectl apply -f deployment/
kubectl apply -f ingress/
kubectl apply -f pv/
kubectl apply -f service/

#Imperatively updating k8s deployments
kubectl set image deployments/client-deployment multiapp-client=home1docker1/multi-client:$COMMIT_SHA
kubectl set image deployments/server-deployment multiapp-server=home1docker1/multi-server:$COMMIT_SHA
kubectl set image deployments/worker-deployment multiapp-worker=home1docker1/multi-worker:$COMMIT_SHA