FROM cgr.dev/chainguard/go@sha256:f9c2933cb81ca80b37ed7aabd4e02f000f23a24518eb2db18d0fee97552c154c AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:1cfd1bd060c8c46e60778f8e8aa3664e335a57e661e97a448a455454c128851e

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
