FROM mongo:4.2
USER root

# Install openssh-server (this is the missing piece)
RUN apt-get update && apt-get install -y openssh-server && rm -rf /var/lib/apt/lists/*

# Unlock the root account
RUN usermod --unlock root

# Give the 'mongodb' user a valid shell
RUN usermod -s /bin/bash mongodb

# Create the required .ssh directories and set strict permissions
RUN mkdir -p /root/.ssh && chmod 0700 /root/.ssh
RUN mkdir -p /home/mongodb/.ssh && \
    chown -R mongodb:mongodb /home/mongodb && \
    chmod 0700 /home/mongodb/.ssh
