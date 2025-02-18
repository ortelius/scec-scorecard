FROM cgr.dev/chainguard/go@sha256:1dc3baf03d332a079d0417b1885aaf78529c811681191b30fd0840499d9d751c AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:c907cf5576de12bb54ac2580a91d0287de55f56bce4ddd66a0edf5ebaba9feed

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
