FROM golang:1.20.4-alpine3.18

WORKDIR /workdir
COPY . .
RUN go build

CMD ["./client"]
