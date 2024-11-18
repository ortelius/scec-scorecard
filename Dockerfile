FROM cgr.dev/chainguard/go@sha256:aa1ca38e2137f73d2de46f2b9c1fad57b01d7441ab91096ec900118d9b1cf8c2 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:d000aed862c42a81317eccd6aa10a5ad3eadd29b3483d7340e1b44ae1de81641

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
