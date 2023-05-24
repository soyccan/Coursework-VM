FROM golang:1.20.4-alpine3.18

EXPOSE 5310
WORKDIR /workdir
COPY . .
RUN go build

CMD ["./server"]
