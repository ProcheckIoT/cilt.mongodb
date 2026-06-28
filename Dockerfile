FROM mongo:7.0
USER root

RUN apt-get update && \
    apt-get install -y openssh-server && \
    rm -rf /var/lib/apt/lists/*

RUN usermod --unlock root
RUN usermod -s /bin/bash mongodb

RUN mkdir -p /root/.ssh && chmod 0700 /root/.ssh
RUN mkdir -p /home/mongodb/.ssh && \
    chown -R mongodb:mongodb /home/mongodb && \
    chmod 0700 /home/mongodb/.ssh
