FROM cgr.dev/chainguard/go@sha256:66381801d78f19f2419afb27bdc5a5c0645bee03a98f046f200a2051657fa350 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:293478a7d9a5c12e61088b6ba20c5356070cbc5fbb84da30ec4c49bd9278f447

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
