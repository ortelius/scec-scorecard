FROM cgr.dev/chainguard/go@sha256:71cc7c9c98f90655954da09116b4bcfb304fee9628fac3b60158c16bb881889e AS builder

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
