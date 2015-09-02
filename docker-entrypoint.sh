#!/bin/sh

# The myid file consists of a single line containing only the text of that machine's id.
# So myid of server 1 would contain the text "1" and nothing else. The id must be unique within the
# ensemble and should have a value between 1 and 255.
echo ${MY_ID:-1} > /data/zookeeper/myid

#Build the zookeeper config
cat > /opt/zookeeper/conf/zoo.cfg <<EOF
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/data/zookeeper
clientPort=2181
EOF

# server.1=...
if [ -n "$ENSEMBLE_HOST_NAMES" ]; then
    python -c "print '\n'.join(['server.%i=%s:2888:3888' % (i + 1, '0.0.0.0' if (i + 1 == int($MY_ID)) else x) for i, x in enumerate('$ENSEMBLE_HOST_NAMES'.split(','))])" >> /opt/zookeeper/conf/zoo.cfg
fi

exec "$@"