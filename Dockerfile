FROM cgr.dev/chainguard/go@sha256:247e3abdebc14fe35810eb443340996b1c3247ba88c82c377c4a89940c91ce0d AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:0c09bcfc6a1f8755b7a20bd7550e0448adc75d75d22baddd57d9b87577d3f8b4

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
