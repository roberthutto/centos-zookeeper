#!/bin/sh

# Writes the myid based on the the passed docker env variable. i.e MY_ID=1
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

# Writes the servers inn the cluster based on the passed in docker env ENSEMBLE_HOST_NAMES which is a ordered comma
# separated list such that myId should correspond to the position in the list of this node. When myId matches the
# position in the list then 0.0.0.0 is substituted so that the node binds to 0.0.0.0:3888
# Example ENSEMBLE_HOST_NAMES=172.0.0.1,172.0.0.2 and MY_ID=2 results in
# server.1=172.0.0.1:2888:3888
# server.2=0.0.0.0:2888:3888
# zookeeper.out should log
# [myid:2] - INFO  [Thread-1:QuorumCnxManager$Listener@504] - My election bind port: /0.0.0.0:3888
if [ -n "$ENSEMBLE_HOST_NAMES" ]; then
    python -c "print '\n'.join(['server.%i=%s:2888:3888' % (i + 1, '0.0.0.0' if (i + 1 == int($MY_ID)) else x) for i, x in enumerate('$ENSEMBLE_HOST_NAMES'.split(','))])" >> /opt/zookeeper/conf/zoo.cfg
fi

exec "$@"


##TODO update the zookeeper/conf/log4j.properties
# zookeeper.log.dir=.
# zookeeper.tracelog.dir=.
# to use /data/zookepers/logs