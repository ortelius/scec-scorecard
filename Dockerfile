FROM cgr.dev/chainguard/go@sha256:6dd62ce5c2090598f0432c2d61fd423049ae46a5ab5fee57b3f1f71e349b1072 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:1596d00da637ed14b64d1652cf553df9b108d56ae515fbfe662af7f084e7e7d8

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
