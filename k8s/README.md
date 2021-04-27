#### Para ejecutar pruebas con pod-chaos-testing primero hay que tener desplegado el siguiente deployment

`
kubectl apply -f pod-chaos-monkey.yaml
`

#### Ese deployment elimina pods durante unos segundos y los vuelve a regenerar
- Está configurado para que sean 15 segundos de delay desde que borra un pod hasta que lo regenerea

#### Para realizar las pruebas:
- (OPCIONAL) `kubectl delete all --all`
-  
- `kubectl apply -f k8s/db.yaml`
-  
- `kubectl apply -f k8s/webapp-single-pod.yaml`
- `artillery run artillery/artillery.yaml -o artillery/out-single-pod-no-caos.json`
-  
- `kubectl apply -f k8s/pod-chaos-monkey.yaml`
- A PARTIR DE AQUÍ DEBERÍA HABER LLAMADAS QUE DEN ERRORES DEBIDO A QUE LOS PODS SE VAN REGENERANDO  
-  
- `artillery run artillery/artillery.yaml -o artillery/out-single-pod-caos.json`
-
- `kubectl delete -f k8s/webapp-single-pod.yaml`
-  
- `kubectl apply -f k8s/webapp-two-pods.yaml`
- `artillery run artillery/artillery.yaml -o artillery/out-two-pods-caos.json`
- 
- `kubectl apply -f k8s/istio.yaml`
- `kubectl apply -f k8s/istio-service.yaml`
- `artillery run artillery/artillery.yaml -o artillery/out-two-pods-caos-gateway.json`
-