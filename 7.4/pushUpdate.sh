#/bin/bash

docker build -t 4alldigital/drudock-php:7.4 . --no-cache
docker push 4alldigital/drudock-php:7.4
