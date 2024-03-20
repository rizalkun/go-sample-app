FROM golang:1.22.1-alpine3.19 as base
WORKDIR /builder

ENV GO111MODULE=on CGO_ENABLED=0 GIN_MODE=release

COPY go.mod go.sum /builder/
RUN go mod download

COPY . .

RUN go build -o /builder/main /builder/main.go

# runner image
FROM gcr.io/distroless/static:latest

WORKDIR /app

COPY --from=base /builder/main main

EXPOSE 3000

CMD ["/app/main"]
