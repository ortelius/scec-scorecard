FROM cgr.dev/chainguard/go@sha256:f9a48c576a68ae3e4876a8ca8627027147d009f14894de60ef0d5f2dcc9635b2 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:10f3db9e85db0610dfda231fc7326f963d0d7b062491e737dc5e81c875f50c29

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
