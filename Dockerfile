FROM cgr.dev/chainguard/go@sha256:d4eca2743c956f971bd5e3ce96a530109093615dc30be4827769d8f85861b5c2 AS builder

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
