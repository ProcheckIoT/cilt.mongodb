FROM mongo:7.0
USER root

# Install openssh-server
RUN apt-get update && \
    apt-get install -y openssh-server && \
    rm -rf /var/lib/apt/lists/*

# Unlock root so Render can SSH in as root
RUN usermod --unlock root

# Give mongodb user a real shell (in case Render uses it)
RUN usermod -s /bin/bash mongodb

# SSH requires this directory to exist at runtime
RUN mkdir -p /var/run/sshd

# Set up root SSH dir with correct permissions
RUN mkdir -p /root/.ssh && chmod 0700 /root/.ssh

# Set up mongodb SSH dir with correct permissions
RUN mkdir -p /home/mongodb/.ssh && \
    chown -R mongodb:mongodb /home/mongodb && \
    chmod 0700 /home/mongodb/.ssh

# Startup script: launch sshd then hand off to mongo's entrypoint
RUN printf '#!/bin/bash\nset -e\n/usr/sbin/sshd\nexec docker-entrypoint.sh "$@"\n' > /start.sh && \
    chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
CMD ["mongod"]
