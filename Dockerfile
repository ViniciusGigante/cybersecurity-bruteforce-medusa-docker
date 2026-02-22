FROM kalilinux/kali-rolling

COPY requirements.txt /tmp/requirements.txt

RUN apt-get update && \
    apt-get install -y $(tr -d '\r' < /tmp/requirements.txt) && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root