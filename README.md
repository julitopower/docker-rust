# Usage

Pull the images from

[DockerHub](https://hub.docker.com/r/julitopower/rustemacs/tags?page=1&ordering=last_updated).

```
$ docker pull julitopower/rustemacs:$TAG
```

Try it out by starting a temporary, interactive container.

```
$ docker run -it --rm julitopower/rustemacs:$TAG
```

# Updating

Edit the `RUST_VERSION` environment variable in the Dockerfile and run

```
$ docker build -t julitopower/rustemacs:1.31.1 .    # replace version as needed
```

Test it according to the usage instructions above. If it works as
expected, push the image to Dockerhub:

```
$ docker push julitopower/rustemacs:1.31.1
```

Lastly, update the latest tag and push it too. For example:

```
$ docker build -t julitopower/rustemacs:latest .
$ docker push julitopower/rustemacs:latest
```

# Available images in Dockerhub:

## latest

Current points to 1.48.0:

```
docker pull julitopower/rustemacs
```

## 1.48.0

Based on Ubuntu-20.10

```
docker pull julitopower/rustemacs:1.48.0
```

## 1.31.1

Based on Ubuntu-16.04

```
docker pull julitopower/rustemacs:1.31.1
```


