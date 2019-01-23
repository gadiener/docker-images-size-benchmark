# POC: Docker images size benchmark

## Build single image

```bash
docker build -t simple-server -f images/${DOCKERFILE_NAME} context
```

## Run the container

```bash
open http://localhost:3000 && docker run -p 3000:3000 simple-server
```

## Run tests

```bash
./bench --help
```

## Results

**Normal build from Golang image `Dockerfile-golang`:**

- Build time: 3105.837 microseconds
- Total size: 781MB
- Total layers without empty ones: 8
- Total layers: 16

**Multi stage build from Google distroless image `Dockerfile-distroless`:**

- Build time: 3709.062 microseconds
- Total size: 23.4MB
- Total layers without empty ones: 3
- Total layers: 5

**Multi stage build from Alpine image `Dockerfile-alpine`:**

- Build time: 3688.356 microseconds
- Total size: 10.8MB
- Total layers without empty ones: 2
- Total layers: 5

**Multi stage build from Alpine image `Dockerfile-busybox`:**

- Build time: 16008.799 microseconds
- Total size: 7.7MB
- Total layers without empty ones: 2
- Total layers: 5

**Multi stage build from scratch image `Dockerfile-scratch`:**

- Build time: 14977.498 microseconds
- Total size: 6.5MB
- Total layers without empty ones: 1
- Total layers: 3
