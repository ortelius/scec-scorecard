FROM cgr.dev/chainguard/go@sha256:63f102c081355472489b4eac1a380e3117ce76fadc9597d7774c1c2802487274 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:1503eba5de2a5ac63db87f8ebd9c28af3deaa377a47b22304c68035fae8902d6

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
