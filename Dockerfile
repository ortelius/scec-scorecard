FROM cgr.dev/chainguard/go@sha256:44413c239ba0eb118d6297cb5a2f7537912011fc3ace74030812501fd235b529 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:1a22f5e3a75e1e48fd63e5026df5645cef1f9d2d1ccf872cfa867ebee761692f

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
