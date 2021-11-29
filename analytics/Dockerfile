# Source https://github.com/GoogleCloudPlatform/golang-samples/blob/6c46053696035e0b5d210806f005c43da9bcb6ee/cloudsql/postgres/database-sql/Dockerfile 
# us-central1-docker.pkg.dev/gkepoctoolkit/analytics-server/analytics-server:v0.0.1 

FROM golang:1.16-buster as builder

# Create and change to the app directory.
WORKDIR /app

# Retrieve application dependencies.
# This allows the container build to reuse cached dependencies.
# Expecting to copy go.mod and if present go.sum.
COPY go.* ./
RUN go mod download

# Copy local code to the container image.
COPY . ./

# Build the binary.
RUN go build -v -o server

# Use the official Debian slim image for a lean production container.
# https://hub.docker.com/_/debian
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM debian:buster-slim
RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy the binary to the production image from the builder stage.
COPY --from=builder /app/server /app/server

# Run the web service on container startup.
WORKDIR /app
EXPOSE 8000
CMD ["/app/server"]
