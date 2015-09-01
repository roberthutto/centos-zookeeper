# centos-zookeeper

ZooKeeper

https://zookeeper.apache.org/

[![](https://badge.imagelayers.io/roberthutto/centos-zookeeper.svg)](https://imagelayers.io/?images=roberthutto/centos-zookeeper)

Example

docker run --name some-zookeeper \
-e MY_ID=1 -e ENSEMBLE_HOST_NAMES=Node1,Node2 \
-p 2181:2181 -p 2888:2888 -p 3888
-d roberthutto/centos-zookeeper