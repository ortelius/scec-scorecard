FROM cgr.dev/chainguard/go@sha256:0618d000173ae64cdebcbc7ed1023365f69b4234ba3918bf0b0dccd942550303 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:381cc5992555a7ebb75f2a500d334e2a1efa0f35fb7e0edafccb6bb0bef264ae

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
