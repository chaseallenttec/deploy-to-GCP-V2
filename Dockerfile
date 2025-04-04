# Build stage
FROM golang:1.23 as builder

WORKDIR /go/src/app
COPY eva-api-server/go-files .

RUN go mod download
RUN go build -o /go/bin/eva-api-server-go

# Final stage
FROM almalinux:latest

# Install dependencies
RUN yum -y update && \
    yum install -y epel-release curl gcc openssl-devel bzip2-devel libffi-devel \
    nano nmap tcpdump net-tools htop supervisor wget make postgresql-devel python-devel \
    monit && \
    yum clean all

# Copy the Go binary from the builder stage
COPY --from=builder /go/bin/eva-api-server-go /usr/local/bin/eva-api-server-go

# Set the working directory for the application
WORKDIR /etc/eva/eva-api-server

CMD ["/usr/local/bin/eva-api-server-go", "startup.sh"]
