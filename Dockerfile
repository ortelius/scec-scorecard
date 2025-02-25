FROM cgr.dev/chainguard/go@sha256:4597542577b85001588c1f023353c4102e259f308d7f0868144d26db80d0852b AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:334822bb2c72fcd3e1ac4b7021ea32b21d968f1364b4c71d502a0cfe763cec6b

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
