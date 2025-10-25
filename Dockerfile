FROM cgr.dev/chainguard/go@sha256:161ca5580747387dce7fb8b8abd5ea5bb9d7719883a00d4e0dd8d942f80e67c5 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:1b4f817a6b39a52835dca3d7de7994e4b49afbb2e8590852b0fac860d457fb6f

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
