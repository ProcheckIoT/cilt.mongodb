FROM mongo:latest

# Switch to root to modify the default mongodb user
USER root

# 1. Create a dedicated home directory (must be separate from the database volume)
# 2. Give the user a valid bash shell for Render SSH access
# 3. Create the .ssh directory
# 4. Set ownership and the strict permissions required by Render
RUN mkdir -p /home/mongodb && \
    usermod -d /home/mongodb -s /bin/bash mongodb && \
    mkdir -p /home/mongodb/.ssh && \
    chown -R mongodb:mongodb /home/mongodb && \
    chmod 0700 /home/mongodb/.ssh

# Switch back to the non-root user to run the database
USER mongodb
