# Build stage
FROM golang:1.25-alpine AS builder

WORKDIR /app

# Copy dependency files first for better layer caching
COPY go.mod go.sum ./
RUN go mod download

# Copy application source
COPY app/ ./app/

# Build static binary
RUN CGO_ENABLED=0 GOOS=linux go build -o /counter ./app

# Runtime stage
FROM alpine:3.21

RUN apk add --no-cache ca-certificates

WORKDIR /app

# Copy binary from builder
COPY --from=builder /counter .

EXPOSE 8080

CMD ["./counter"]