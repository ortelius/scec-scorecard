FROM cgr.dev/chainguard/go@sha256:59ed435309d63eca77790d96d35e60fa9dd089cecb8e933d8dd98388eaee1e9a AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:08d1d30d0909f790475abac54d9e1873b3007df21360ff1c3524e96a6da5c1e6

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
