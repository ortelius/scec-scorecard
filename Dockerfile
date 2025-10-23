FROM cgr.dev/chainguard/go@sha256:498864eeafffdf96f157a7faaad80297bf6bb3a11f6966f0373707e500ec8b14 AS builder

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
