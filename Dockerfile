FROM cgr.dev/chainguard/go@sha256:5afc5b8b837437e29d425da5e4c182159843a01f2b3d1e8bbcbcc6648d8f3b25 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:3273a7d0434f404670da10a69a196d20b59d60c69290bf4cd3882e9129de8a58

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
