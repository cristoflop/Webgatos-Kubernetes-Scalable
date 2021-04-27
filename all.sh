kubectl delete all --all
kubectl apply -f k8s/db.yaml
kubectl apply -f k8s/webapp-single-pod.yaml
artillery run artillery/artillery.yaml -o artillery/out-single-pod-no-caos.json
kubectl apply -f k8s/pod-chaos-monkey.yaml
artillery run artillery/artillery.yaml -o artillery/out-single-pod-caos.json
kubectl delete -f k8s/webapp-single-pod.yaml
kubectl apply -f k8s/webapp-two-pods.yaml
artillery run artillery/artillery.yaml -o artillery/out-two-pods-caos.json
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.9.4
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
cd ..
kubectl apply -f k8s/istio/istio.yaml
kubectl apply -f k8s/istio/istio-service.yaml
artillery run artillery/artillery.yaml -o artillery/out-two-pods-caos-gateway.json
