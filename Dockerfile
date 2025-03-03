FROM cgr.dev/chainguard/go@sha256:6622d8ca2e197aa68ae980a4fab6ce4f866ca4fca0e6aa0a45374078b9ea39e3 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:cdbc98c185b030bb747a53162c210ca513b8bbb8f12148c2943fb24babc597a3

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
