FROM cgr.dev/chainguard/go@sha256:2662b409fdc9c584b921e15c3083a0b9bace8b05c69bbe429b9db256879d18e1 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:b907bb399c7ba663a51fd67d0e082de7b456d21a05a3ffca9d16096e16786e6f

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
