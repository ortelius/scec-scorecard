FROM cgr.dev/chainguard/go@sha256:dcbc6fbe5dd829aa5ce8eceb3466c3b26f7e8ce3c3b7561719297d2b69381fb0 AS builder

WORKDIR /app
COPY . /app

RUN go install github.com/swaggo/swag/cmd/swag@latest; \
    /root/go/bin/swag init; \
    go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:b6d081a888e083ae88541c6da0c6c08077bb6b60c04b21813e7eea92d900e4be

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
