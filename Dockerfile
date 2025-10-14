FROM cgr.dev/chainguard/go@sha256:c4b2693922144783221ece047d3338ddf2d9417a7e4d31020e44caa2c9b100e7 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:8ae601f58dcc73f7c973ffe84e3641f566cba28225cb70e8237f155ac72725a8

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
