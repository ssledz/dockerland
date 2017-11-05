# dockerland
Repository for Dockerfiles


## Pushing to Docker Hub
```
docker run --name jdk-1.8 -it ssledz/jdk-1.8
docker commit -m 'Initial commit' -a "Sławomir Śledź" jdk-1.8 ssledz/jdk-1.8:latest
docker login
docker push ssledz/jdk-1.8:latest
```
