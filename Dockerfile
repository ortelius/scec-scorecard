FROM cgr.dev/chainguard/go@sha256:e5b2f3dd0495f1bdd374e599a14ad6f836de635da4702395fd1f7f0212d5eb40 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:e1912ecfee19bed77a2d9ad0584fa84578f47b602b7f16f4efd4b3d5ffafb9a2

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
