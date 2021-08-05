# Applying two tags to each image so kubectl updates when we apply them
# The 1st one is the usual "latest" tag (which would have been applied automatically if we'd only need one tag)
# The 2nd tag is used to always make a different tag to make kubectl recognise there was a change. GIT SHA is a unique token identifying the current state of the code base
docker build -t pnantunes/multi-client:latest -t pnantunes/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t pnantunes/multi-server:latest -t pnantunes/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t pnantunes/multi-worker:latest -t pnantunes/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push pnantunes/multi-client:latest
docker push pnantunes/multi-server:latest
docker push pnantunes/multi-worker:latest

docker push pnantunes/multi-client:$SHA
docker push pnantunes/multi-server:$SHA
docker push pnantunes/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=pnantunes/multi-server:$SHA
kubectl set image deployments/client-deployment client=pnantunes/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=pnantunes/multi-worker:$SHA