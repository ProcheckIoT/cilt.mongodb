FROM mongo:4.2

# Ensure we are operating as root for the setup
USER root

# 1. Unlock the root account (Render SSH requirement)
RUN usermod --unlock root 

# 2. Give the 'mongodb' user a valid shell (Render SSH requirement)
RUN usermod -s /bin/bash mongodb
