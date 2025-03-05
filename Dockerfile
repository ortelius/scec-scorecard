FROM cgr.dev/chainguard/go@sha256:f0abd9302692f8613919325756f0878d5cfbde6e519635e10d3b3db07ad199ef AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:01e8e67b02de86761e51ee0ba73366f476c830a79e592a2179bcb9d491dc0050

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
