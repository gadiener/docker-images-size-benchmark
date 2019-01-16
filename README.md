# POC: Docker images size benchmark

## Usage

### Build image

```bash
docker build -t simple-server -f ${DOCKERFILE_NAME} .
```

### Run image

```bash
docker run -p 3000:3000 simple-server & open http://localhost:3000
```

## Size benchmark

Normal build from golang image `Dockerfile`: 781MB

Multi stage build from Google distroless image `Dockerfile-distroless`: 23.4MB

Multi stage build from Alpine image `Dockerfile-alpine`: 11MB

Multi stage build from Alpine image `Dockerfile-busybox`: 7.7MB

Multi stage build from scratch image `Dockerfile-scratch`: 6.5MB