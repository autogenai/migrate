FROM golang:1.25-alpine3.23 AS builder
ARG VERSION

RUN apk add --no-cache git gcc musl-dev make ca-certificates

WORKDIR /go/src/github.com/golang-migrate/migrate

ENV GO111MODULE=on

COPY go.mod go.sum ./

RUN go mod download

COPY . ./

RUN make build-docker VERSION=$VERSION

FROM ghcr.io/autogenai/images/alpine-base:3.23

COPY --from=builder --chown=999:999 /go/src/github.com/golang-migrate/migrate/build/migrate.linux-386 /usr/local/bin/migrate

USER 999
ENTRYPOINT ["/usr/local/bin/migrate"]
CMD ["--help"]
