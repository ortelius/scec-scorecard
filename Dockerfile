FROM cgr.dev/chainguard/go@sha256:5e6348886cf06f56f6e9a78cd6fb0cd3e4b4d896b27653f448ca722b528c460a AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:31073f3a1add4bfc3ce4ee474ee171bf9dcc9799a468a39c8180c45ddf11c883

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
