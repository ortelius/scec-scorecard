FROM cgr.dev/chainguard/go@sha256:8e84488b7741551f7239738b5eb67e38494a82b3042f18c24e1c0867c96ed8f4 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:90c3d6a7b820f594e7a65cc4105c5a5e2203496fbd1d768f016bbf1b7fab0be6

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
