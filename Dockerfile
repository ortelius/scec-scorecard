FROM cgr.dev/chainguard/go@sha256:18ac853fb4aae33f972b775535a1e54fc2dac1438a901932aa5a469115adfc99 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:1503eba5de2a5ac63db87f8ebd9c28af3deaa377a47b22304c68035fae8902d6

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
