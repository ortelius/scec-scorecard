FROM cgr.dev/chainguard/go@sha256:f5351d68775976a1154fb333b905c23958d2d2b59c91af86317c939eb9b24b63 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:293478a7d9a5c12e61088b6ba20c5356070cbc5fbb84da30ec4c49bd9278f447

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
