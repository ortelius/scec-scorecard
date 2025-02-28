FROM cgr.dev/chainguard/go@sha256:892f2fb890eceafd98c46fc1487f70726cb32fcfe89cb3b51abef6388f587853 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:cdbc98c185b030bb747a53162c210ca513b8bbb8f12148c2943fb24babc597a3

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
