#/bin/bash

docker build -t 4alldigital/drudock-php:8.0 . --no-cache
docker push 4alldigital/drudock-php:8.0
