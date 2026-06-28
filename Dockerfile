FROM mongo:4.2

USER root

# 1. Unlock the root account
RUN usermod --unlock root 

# 2. Give the 'mongodb' user a valid shell
RUN usermod -s /bin/bash mongodb

# 3. Create the required .ssh directories and set strict permissions
RUN mkdir -p /root/.ssh && chmod 0700 /root/.ssh
RUN mkdir -p /home/mongodb/.ssh && \
    chown -R mongodb:mongodb /home/mongodb && \
    chmod 0700 /home/mongodb/.ssh
