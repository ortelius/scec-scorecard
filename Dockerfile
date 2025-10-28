FROM cgr.dev/chainguard/go@sha256:0cc724fbc2842fc31d96d7bfa5cd06216efdf240375dece73998e2f7be1c8c09 AS builder

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
