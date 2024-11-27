FROM cgr.dev/chainguard/go@sha256:c2b23e88bc79ce02070f569ff7fa57362c4caa644ff91d73fd69aeb6e6b38d0a AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:a2ecbc3d413b9a286e98182f7d4fcfbb10bb75e10e7c99b4ac59b5c7f982ed7d

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
