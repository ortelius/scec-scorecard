FROM cgr.dev/chainguard/go@sha256:2e4c0d22e2006773de839b4d18c420e502927b5c10b449f45ce7af4b41309755 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:e4df2eec5a28c5ad61bb3e172172549ffc95c0432ead7edd7ba37916a258d843

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
