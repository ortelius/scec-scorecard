FROM cgr.dev/chainguard/go@sha256:829594acdbc0f50ea5cae9ae208224999c21d1ee3dfe8003b177814056a827f1 AS builder

WORKDIR /app
COPY . /app

RUN go install github.com/swaggo/swag/cmd/swag@latest; \
    /root/go/bin/swag init; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:268454fc5e9bd468f51aa691950a5aeef52fe68a6b0de23786a331fae74ebdde

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
