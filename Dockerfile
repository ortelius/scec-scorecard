FROM cgr.dev/chainguard/go@sha256:401ca3dc3235348f8d9eade54cb0c4d16d1816f3f35935636e9615125c541f00 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:90c3d6a7b820f594e7a65cc4105c5a5e2203496fbd1d768f016bbf1b7fab0be6

WORKDIR /app

COPY --from=builder /app/main .
COPY --from=builder /app/docs docs

ENV ARANGO_HOST localhost
ENV ARANGO_USER root
ENV ARANGO_PASS rootpassword
ENV ARANGO_PORT 8529
ENV MS_PORT 8080

EXPOSE 8080

ENTRYPOINT [ "/app/main" ]
