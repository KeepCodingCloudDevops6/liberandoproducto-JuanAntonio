# liberandoproducto-JuanAntonio


El objetivo de está practica es mejorar un proyecto ya creado.

Se pide lo siguiente:

    UtilIzar FastAPI para poder levantar un servidor en el puerto 8081 y lanzar dos endpints
    Utilizar test unitarios Para el servidor FastAPI Utiliza prometheus-client para arrancar un servidor de métricas en el puerto 8000 y poder registrar métricas, siendo inicialmente las siguientes:

Tenemos que tener instalado las siguiente programa o aplicaciones:

    Python en versión 3.8.5 o superior
    virtualenv para poder instalar las librerias de python
    Docker para poder arrancar el servidor implementado por un contenedor.

Ejecutar el servidor:

Instalación de un virtualenv, realizarlo sólo en caso de no haberlo realizado:

    -Obtener la versión actual de Python instalada para crear posteriormente un virtualenv:

    python3 --version

    El comando anterior mostrará algo como lo mostrado a continuación:

        Python 3.8.13

    Crear de virtualenv en la raíz del directorio para poder instalar las librerías necesarias:

        En caso de en el comando anterior haber obtenido Python 3.8.*

        python3.8 -m venv venv

        En caso de en el comando anterior haber obtenido Python 3.9.*:

        python3.9 -m venv venv

Activar el virtualenv creado en el directorio venv en el paso anterior:

source venv/bin/activate

Instalar las librerías necesarias de Python, recogidas en el fichero requirements.txt, sólo en caso de no haber realizado este paso previamente. Es posible instalarlas a través del siguiente comando:

pip3 install -r requirements.txt

Ejecución del código para arrancar el servidor:

python3 src/app.py

La ejecución del comando anterior debería mostrar algo como lo siguiente:

[2022-04-16 09:44:22 +0000] [1] [INFO] Running on http://0.0.0.0:8081 (CTRL + C to quit)

Ejecución a través de un contenedor Docker

Crear una imagen Docker con el código necesario para arrancar el servidor:

docker build -t simple-server:0.0.1 .

Arrancar la imagen construida en el paso anterior mapeando los puertos utilizados por el servidor de FastAPI y el cliente de prometheus:

docker run -d -p 8000:8000 -p 8081:8081 --name simple-server simple-server:0.0.1

Obtener los logs del contenedor creado en el paso anterior:

docker logs -f simple-server

La ejecución del comando anterior debería mostrar algo como lo siguiente:

[2022-04-16 09:44:22 +0000] [1] [INFO] Running on http://0.0.0.0:8081 (CTRL + C to quit)

Comprobar si se ha instalado el endpoint y las métricas:


Realizar una petición al endpoint /

curl -X 'GET' \
'http://0.0.0.0:8081/' \
-H 'accept: application/json'

Debería devolver la siguiente respuesta:

{"message":"Hello World"}

Realizar una petición al endpoint /health

curl -X 'GET' \
'http://0.0.0.0:8081/health' \
-H 'accept: application/json' -v

Debería devolver la siguiente respuesta.

{"health": "ok"}

Comprobación de registro de métricas, si se accede a la URL http://0.0.0.0:8000 se podrán ver todas las métricas con los valores actuales en ese momento:

Realizar varias llamadas al endpoint / y ver como el contador utilizado para registrar las llamadas a ese endpoint, main_requests_total ha aumentado, se debería ver algo como lo mostrado a continuación:

# TYPE main_requests_total counter
main_requests_total 4.0

Realizar varias llamadas al endpoint /health y ver como el contador utilizado para registrar las llamadas a ese endpoint, healthcheck_requests_total ha aumentado, se debería ver algo como lo mostrado a continuación:

# TYPE healthcheck_requests_total counter
healthcheck_requests_total 26.0

También se ha credo un contador para el número total de llamadas al servidor server_requests_total, por lo que este valor debería ser la suma de los dos anteriores, tal y como se puede ver a continuación:

# TYPE server_requests_total counter
server_requests_total 30.0

Realizar test: 

Se ha implementado tests unitarios para probar el servidor FastAPI, estos están disponibles en el archivo src/tests/app_test.py.

Es posible ejecutar los tests de diferentes formas:

Ejecución de todos los tests:

pytest

Ejecución de todos los tests y mostrar cobertura:

pytest --cov

Ejecución de todos los tests y generación de report de cobertura:

pytest --cov --cov-report=html
