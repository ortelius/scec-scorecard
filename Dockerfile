FROM cgr.dev/chainguard/go@sha256:ad528ff2a19171992043fd65761937a8c83e812ece0d6081e653c61e74f1aea3 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:17f942295bb0ba9c1d27c06382d4a999bc8becc5cf6bbcbde0af0baa00b9b470

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
