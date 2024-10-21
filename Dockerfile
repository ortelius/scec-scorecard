FROM cgr.dev/chainguard/go@sha256:e54608ec6d027e08c570db2a0405ac1c8318e167769dd2303b4b1e92db6d35b1 AS builder

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
