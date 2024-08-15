FROM cgr.dev/chainguard/go@sha256:9765bc68d221c6917e009e2d53abdd86469cd40673093eab4c7c0bcfb92a82ec AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:a76418d2b76f678fba9e8b29b8545bd35b3ca1e69827e532db175b0143337c1a

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
