# Escalabilidad y tolerancia a fallos

Esta aplicación asigna un color aleatorio a cada usuario que se conecta. En las sucesivas peticiones a la web, se genera la página con el color asignado inicialmente.

Para hacer esto, hace uso de la sesión HttpSession proporcionada por el framework Java EE.

Para construir la aplicación y publicarla en DockerHub se usa el plugin maven JIB con el comando:

- EDIT:
Primero hay que desplegar los servicios para que pasen los test al compilar con maven (los pasos están debajo, al usar minikube para desplegar los servicios, hay que cambiar el tipo del servicio de webapp, minikube solo acepta ClusterIP o NodePort, si se usa el contexto de docker-desktop no hace falta porque si acepta el tipo LoadBalancer)

- Además antes de ejecutar el comando, cambiar el puerto del método loadPage() en el test al puerto del servicio.
  Este puerto es el puerto del deployment si se usa el contexto de 'docker-desktop'
  Si se usa minikube hay que obtener el puerto que externaliza el contenedor del servicio (mas abajo se explica como obtenerlo)
  
```
$ mvn clean package
```

Para desplegar la aplicación en Kubernetes se usan los comandos

 - Si se quiere usar el contexto de minikube, primero:
```
$ minikube start
```

    MINIKUBE NO DESPLIEGA LOS SERVICIOS EN LOCALHOST, LOS DESPLIEGA EN SU CONTENEDOR INTERNO, Y LOS EXPONE A LOCALHOST EN UN PUERTO LIBRE ELEGIDO POR EL
    PARA OBTENER ESE PUERTO, DESDE LENS, ACCEDEMOS A LOS SERVICIOS DESPLEGADOS, Y EN LOS SERVICIOS QUE USEN NODEPORT, HACEMOS CLIC EN EL PUERTO DISPONIBLE PARA QUE NOS ABRA EL NAVEGADOR CON EL PUERTO QUE SE HA EXTERNALIZADO
    - NOTA: EN MINIKUBE NO SE PUEDE USAR 'LoadBalancer'

```
$ kubectl apply -f k8s/db.yml
```

```
$ kubectl apply -f k8s/webapp.yml
```

En minikube, se puede abrir el browser directamente apuntando al servicio:

```
$ minikube service webapp
```

Para probar el funcionamiento, basta con abrir dos navegadores web y verificar que cada uno de ellos tiene un color diferente.

## Escalado

Para escalar la aplicación basta con pedir a Kubernetes más réplicas del pod:

```
$ kubectl scale deployments/webapp --replicas=2
```

Esta web está implementada con ```spring-session```, que mantiene los datos de la sesión en un servicio compartido externo, de forma que varias réplicas pueden acceder a los datos de la sesión. En concreto, en este ejemplo se usa MySQL como sitio centralizado para guardar los datos de la sesión de los usuarios.
 
---

#### Pruebas con artillery

```
Ejecutar fichero all.sh para ir realizando las pruebas de artillery, o ir ejecutando los comandos para ver el proceso mas detallado
```