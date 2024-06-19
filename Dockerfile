FROM cgr.dev/chainguard/go@sha256:ae3a8b7efe98b1fa1faa637e11bba8ff4de33981e76b49eb8cad75520b8ae85d AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:9850190b2e79687e2ffe9948f1648ca780e8a2461dabfb3e275a95f7912f4081

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
