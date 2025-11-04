FROM cgr.dev/chainguard/go@sha256:c95baa2517f33a3d9ec60536f3241275f765be3ca079e75bded303b62d1bd679 AS builder

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
