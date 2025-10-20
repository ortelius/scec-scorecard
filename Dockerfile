FROM cgr.dev/chainguard/go@sha256:f0598f289bd08342f556daaa323e617743e5fa976ac1a1d702bc51621c395240 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:ed3619242595eb5177a3bdae804d113401e37315d2cddba97eeeb4d038560821

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
