#/bin/bash

docker build -t 4alldigital/sonar-scanner .
docker push 4alldigital/sonar-scanner:latest
