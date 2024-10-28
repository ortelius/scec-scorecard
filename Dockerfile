FROM cgr.dev/chainguard/go@sha256:f0f3ac4e6b4d8234ee0bef11017a95e0ac54df7aeaf223506b7fd66b54a7a005 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:49f953b74245c8d411defdab86d21c4bc59dc24ed8bb166c1e7e0779f7f1deed

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
