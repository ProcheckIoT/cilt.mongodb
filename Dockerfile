FROM mongo:latest

USER root

# 1. Create a home directory for the mongodb user
# 2. Assign the universal /bin/sh shell
# 3. Explicitly unlock the mongodb system account (-U) so SSH connections are allowed
# 4. Set up the strict permissions Render requires for the .ssh directory
RUN mkdir -p /home/mongodb && \
    usermod -d /home/mongodb -s /bin/sh mongodb && \
    usermod -U mongodb || true && \
    mkdir -p /home/mongodb/.ssh && \
    chown -R mongodb:mongodb /home/mongodb && \
    chmod 0700 /home/mongodb/.ssh

USER mongodb
EXPOSE 27017
