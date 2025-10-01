FROM cgr.dev/chainguard/go@sha256:50b45e309db68372d282ea8c7c87a2d630523c09e9c16cbe30ea90b343eabd79 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:a840f9604b5b567eb8940be269493b8c25c2a92e15c18121f594e317a9dac886

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
