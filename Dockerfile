FROM cgr.dev/chainguard/go@sha256:39ab5e4870b2ad5312638b492deda1155762a7a1870020717307fd901bb9030a AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:8ae601f58dcc73f7c973ffe84e3641f566cba28225cb70e8237f155ac72725a8

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
