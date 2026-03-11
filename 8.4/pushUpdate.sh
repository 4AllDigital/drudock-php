#/bin/bash

docker build -t 4alldigital/drudock-php:8.4  --platform linux/amd64 . --no-cache
docker push 4alldigital/drudock-php:8.4
