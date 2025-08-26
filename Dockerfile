FROM cgr.dev/chainguard/go@sha256:82090ed70cd6b046b8838c5273d89cb32f178eebc64f43b2203725e2cb58c176 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:ae572bb763adb26db7e99304d0f5b821511480de6317089160a83c1f112e6a33

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
