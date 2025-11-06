FROM cgr.dev/chainguard/go@sha256:29a0adfe44eb795f3349a271bb7fcdbb04211bd81c3ab4fdfb11d3e468a6a71c AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:def5ae4cdeef935b2d4b55b03eccd695ec114b029e46b8515b04032a4cdd3909

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
