FROM cgr.dev/chainguard/go@sha256:6d7d08fd6e67dae255b3229c11bdb6216d6e5a0698baa92c938c3961654c5f31 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:ed558c29f9bfa30a59f97ddd4f62d6db9fc47992d22346888ebda610f09c9a5f

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
