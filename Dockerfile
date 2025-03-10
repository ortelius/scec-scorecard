FROM cgr.dev/chainguard/go@sha256:cb07cb05425ec6499a500d1c04294444f4134f70ea6a075980aa6ee90884154b AS builder

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
