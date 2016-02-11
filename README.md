# centos-zookeeper

ZooKeeper

https://zookeeper.apache.org/

[![](https://badge.imagelayers.io/roberthutto/centos-zookeeper.svg)](https://imagelayers.io/?images=roberthutto/centos-zookeeper)


Allows for the creation of single or clustered zookeeper container. 

Example for running a zookeeper cluster of 2. 

There are 2 important configuration parameters that are used to configure zookeeper.
    
    ENSEMBLE_HOST_NAMES which is a csv of ordered hosts i.e. ENSEMBLE_HOST_NAMES=172.0.0.1,172.0.0.2
    is used to configure the "zookeeper/conf/zoo.cfg"

    MY_ID=1 which represents the ID of this zookeeper node and is written to the /data/zookeeper/myid file
    
    ** It is important that MY_ID and ENSEMBLE_HOST_NAMES are configured such that when composing the docker run 
        command that the node that is being created should have a MY_ID that corresponds to the position in the ENSEMBLE_HOST_NAMES.
        Considering the example a MY_ID=2 would be used when starting a docker on 172.0.0.2 which is the 2nd position in the
        ENSEMBLE_HOST_NAMES
        
   
   Optional -v /data/zookeeper:/data/zookeeper to map to a host dir so that zookeeper state is maintained on the host
   
Example 2 hosts zookeeper nodes 172.0.0.1 and 172.0.0.2

On host1=172.0.0.1 the docker run 

        docker run --name zookeeper -v /data/zookeeper:/data/zookeeper -e MY_ID=1 -e ENSEMBLE_HOST_NAMES=172.0.0.1,172.0.0.2 -p 2181:2181 -p 2888:2888 -p 3888:3888 -d roberthutto/centos-zookeeper
        
On host2=172.0.0.2 the docker run     

        docker run --name zookeeper -v /data/zookeeper:/data/zookeeper -e MY_ID=2 -e ENSEMBLE_HOST_NAMES=172.0.0.1,172.0.0.2 -p 2181:2181 -p 2888:2888 -p 3888:3888 -d roberthutto/centos-zookeeper


General run

        docker run --name zookeeper -v /data/zookeeper:/data/zookeeper -e MY_ID=<node_position_in_ensemble_host_names> -e ENSEMBLE_HOST_NAMES=<host1,host2,...> -p 2181:2181 -p 2888:2888 -p 3888:3888 -d roberthutto/centos-zookeeper
