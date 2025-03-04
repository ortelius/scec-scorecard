FROM cgr.dev/chainguard/go@sha256:9d6bb1b9a20fc5700d72be81ac4a0a3010d2745e1156cc07d3486d13b5d28404 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:39ce6359d295367374dc41f3d1c0a3a73ed78b21fe62c2f70d096cb984788c30

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
