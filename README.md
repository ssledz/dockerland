# dockerland
Repository for Dockerfiles


## Pushing to Docker Hub
```
docker run --name java-1.8 -it ssledz/java-1.8
docker commit -m 'Initial commit' -a "Sławomir Śledź" java-1.8 ssledz/java-1.8:latest
docker login
docker push ssledz/java-1.8:latest
```
