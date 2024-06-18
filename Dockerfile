FROM cgr.dev/chainguard/go@sha256:1d4242596ec0bd9759f3141b188a42081c0064173e8ed2364b5dbc4db87419ac AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:d3ea645625291a4cdd066ae073bb8cd7ae4319fe31d8886f789d0b9482eeb353

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
