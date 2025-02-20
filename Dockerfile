FROM cgr.dev/chainguard/go@sha256:05f1dfa71435aabde93c14f84dd741b84c0e038a9daedf9874f232e670b71f6c AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:4c097ad707332d7a8ceaf375b9436229b63e019afbb3a371e67f2de162535187

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
