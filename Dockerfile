FROM mongo:latest

USER root

RUN mkdir -p /home/mongodb && \
    usermod -d /home/mongodb -s /bin/sh mongodb && \
    usermod -U mongodb || true && \
    mkdir -p /home/mongodb/.ssh && \
    chown -R mongodb:mongodb /home/mongodb && \
    chmod 0700 /home/mongodb/.ssh

RUN cat <<'EOF' > /usr/local/bin/start-mongo.sh
#!/bin/sh
set -e

mongod --replSet rs0 --bind_ip_all --auth --dbpath /data/db &
MONGO_PID=$!

until mongosh --quiet --eval "db.adminCommand('ping')" >/dev/null 2>&1; do
  echo "Waiting for mongod to start..."
  sleep 1
done

mongosh --quiet -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin --eval "
  try {
    rs.status();
    print('Replica set already initiated');
  } catch (e) {
    print('Initiating replica set...');
    rs.initiate({
      _id: 'rs0',
      members: [{ _id: 0, host: 'localhost:27017' }]
    });
  }
" || echo "Could not initiate via authenticated session, check credentials"

wait $MONGO_PID
EOF

RUN chmod +x /usr/local/bin/start-mongo.sh && \
    chown mongodb:mongodb /usr/local/bin/start-mongo.sh

USER mongodb
EXPOSE 27017

CMD ["/usr/local/bin/start-mongo.sh"]
