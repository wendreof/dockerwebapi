docker build -t dockerwebapi -f Dockerfile . 

docker run -ti --rm -p 8181:5000 dockerwebapi

http://localhost:8181/weatherforecast

#não serviu para nesse esse
docker create --name dockerwebapi-container dockerwebapi 

***********************ou***********************

docker-compose up -d# dockerwebapi
# dockerwebapi
# dockerwebapi
# dockerwebapi
# dockerwebapi
