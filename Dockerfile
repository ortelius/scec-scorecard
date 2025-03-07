FROM cgr.dev/chainguard/go@sha256:f0abd9302692f8613919325756f0878d5cfbde6e519635e10d3b3db07ad199ef AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:834f28f26a55f99594216188dd4e51c00457e561424551ef4e34099f4752472a

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
