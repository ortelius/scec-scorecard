FROM cgr.dev/chainguard/go@sha256:f5b2020afe494b32094ae053d5de2e157455f62de28a5df23bf42315716e6ad5 AS builder

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
