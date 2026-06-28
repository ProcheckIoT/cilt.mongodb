FROM mongo:latest

USER root

# Unlock the system account and set up a universal interactive shell
RUN mkdir -p /home/mongodb && \
    usermod -d /home/mongodb -s /bin/sh mongodb && \
    usermod -U mongodb || true && \
    mkdir -p /home/mongodb/.ssh && \
    chown -R mongodb:mongodb /home/mongodb && \
    chmod 0700 /home/mongodb/.ssh

USER mongodb
EXPOSE 27017
