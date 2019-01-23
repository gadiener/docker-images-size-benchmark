FROM golang:1.11

WORKDIR /app

COPY main.go .

RUN go build -o server .

CMD ["./server"]