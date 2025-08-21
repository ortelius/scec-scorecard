FROM cgr.dev/chainguard/go@sha256:f8bfc4830b8e268ab2cd5af6f5da67ef8252e8b3408e064326a8ec5d237e8810 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:f280bd47fd58f5d00246a2c4412350540e8915c82127949471fff1172ebd302c

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
