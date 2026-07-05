FROM golang:1.22-alpine AS builder

WORKDIR /app

# Copy only the source code
COPY main.go ./

# Build static binary with CGO disabled and modules turned off
RUN GO111MODULE=off CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o main main.go

# Final minimal runner image
FROM alpine:3.19

WORKDIR /app

COPY --from=builder /app/main .

EXPOSE 8000

CMD ["./main"]
