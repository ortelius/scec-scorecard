FROM cgr.dev/chainguard/go@sha256:d66ff0cd28649902550cf104933e8da72210d94cf65408a911143105633862bc AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:a2ecbc3d413b9a286e98182f7d4fcfbb10bb75e10e7c99b4ac59b5c7f982ed7d

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
