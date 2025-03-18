FROM cgr.dev/chainguard/go@sha256:6383df43cac083dab35a66440b0315661aa562afc9a97eb23dd8844825360d52 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:c76c205a735e16390ecfd4a2404a6f5e834e72b7fce2f2cd587ee3fe11fa35ae

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
