FROM cgr.dev/chainguard/go@sha256:e3ab80042c92d8191ad811aa6c87e417ad6443513ee7fb5886f723804f9f94b1 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:9ef5c084ad7fedad78f7d33c7b5b686b13cc6c9a48342205b2490699797b9796

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
