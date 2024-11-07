FROM cgr.dev/chainguard/go@sha256:dc2191aadd038bd52821278c3014b154eb767499213b13efc35373e1a04c5fe0 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:19daed59c01e09340015c20167092a4d51c397458949857585b946eb109f39b6

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
