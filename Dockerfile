FROM cgr.dev/chainguard/go@sha256:9c1fca4e10894a94adcf48e09b1de2b34e87734508c667dcc5f837baba3da109 AS builder

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
