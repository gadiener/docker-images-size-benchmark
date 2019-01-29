# Docker images size benchmark

Comparison between various images containing the same Golang application.

## How to build a smaller Docker image

When you're building a Docker image it's important to keep the size under control. Having small images means ensuring faster deployment and transfers.

Repository related to the article:
[How to build a smaller Docker image](https://medium.com/@gdiener/how-to-build-a-smaller-docker-image-76779e18d48a)

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

Usage: ./bench.sh [OPTIONS]

Run it.

Options:
    -h, --help         Show help docker
    -v, --verbose      Talk a lot while doing things
    -d, --debug        Enable debug mode, it also activates verbose
        --with-cache   Enable cache on Docker build
        --no-prepull   Disable prepull of base images
        --no-check     Skip dependencies preflight check
        --squash       Squash newly built layers into a single new layer on Docker build
```

## Results

**Normal build from Golang image `Dockerfile-golang`:**

- Build time: 2114.989 microseconds
- Total size: 823MB
- Total layers filled: 8
- Total layers: 16

**Multi stage build from Debian image `Dockerfile-debian`:**

- Build time: 2620.073 microseconds
- Total size: 107MB
- Total layers filled: 2
- Total layers: 5

**Multi stage build from Google distroless image `Dockerfile-distroless`:**

- Build time: 2399.337 microseconds
- Total size: 23.4MB
- Total layers filled: 3
- Total layers: 5

**Multi stage build from Alpine image `Dockerfile-alpine`:**

- Build time: 2553.204 microseconds
- Total size: 10.8MB
- Total layers filled: 2
- Total layers: 5

**Multi stage build from BusyBox image `Dockerfile-busybox`:**

- Build time: 10399.718 microseconds
- Total size: 7.7MB
- Total layers filled: 2
- Total layers: 5

**Multi stage build from scratch image `Dockerfile-scratch`:**

- Build time: 10307.420 microseconds
- Total size: 6.5MB
- Total layers filled: 1
- Total layers: 3
