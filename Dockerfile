FROM cgr.dev/chainguard/go@sha256:b511277be9f1abc329c24c8cbb995a154afb45c0e925bd857fb0d08fef9f383e AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:2186faeb202946cb7953182b210fae464ce40a80836f2b31bac7213e6d59857a

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
