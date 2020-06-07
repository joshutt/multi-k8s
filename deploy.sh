# Build the images
docker build -t fenrir28/multi-client:latest -t fenrir28/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t fenrir28/multi-server:latest -t fenrir28/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t fenrir28/multi-worker:latest -t fenrir28/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# Push images to docker hub
docker push fenrir28/multi-client:latest
docker push fenrir28/multi-server:latest
docker push fenrir28/multi-worker:latest
docker push fenrir28/multi-client:$SHA
docker push fenrir28/multi-server:$SHA
docker push fenrir28/multi-worker:$SHA

# Apply k8s configurations
kubectl apply -f k8s

# Set latest image on each deployment
kubectl set image deployments/server-deployment server=fenrir28/multi-server:$SHA
kubectl set image deployments/client-deployment client=fenrir28/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=fenrir28/multi-worker:$SHA
