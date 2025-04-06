FROM almalinux:latest

RUN dnf update -y

RUN yum -y update
#needed for additional packages like supervisor, htop, etc
RUN yum install epel-release -y
#install remaining packages needed
RUN yum install curl --allowerasing -y
RUN yum -y install gcc openssl-devel bzip2-devel libffi-devel nano nmap tcpdump net-tools htop supervisor wget make postgresql-devel python-devel monit && yum clean all
RUN yum -y update

# Install Go
RUN mkdir -p /etc/eva/eva-api-server/go
RUN mkdir -p /etc/eva/eva-api-server/go-files
RUN wget -O /etc/eva/eva-api-server/go https://dl.google.com/go/go1.23.6.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf /etc/eva/eva-api-server/go/go1.23.1.linux-amd64.tar.gz &&  \
    rm /etc/eva/eva-api-server/go/go1.23.1.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin"
COPY /etc/eva/eva-api-server/go /etc/eva/eva-api-server/go-files
WORKDIR /etc/eva/eva-api-server/go-files
RUN go mod download
RUN go build -o /etc/eva/eva-api-server/eva-api-server-go

WORKDIR .

CMD ["sh", "-c", "cd /etc/eva/eva-api-server && /etc/eva/eva-api-server/startup.sh"]
