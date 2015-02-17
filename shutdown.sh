#!/bin/sh


PID_FILE_NAME="es.pid"

INSTANCES="./ebi_cluster/ebi_node_1/elasticsearch-1.4.3 ./ebi_cluster/ebi_node_2/elasticsearch-1.4.3 ./ebi_cluster/ebi_node_3/elasticsearch-1.4.3 ./urgi_cluster/urgi_node1/elasticsearch-1.4.3 ./urgi_cluster/urgi_node2/elasticsearch-1.4.3 ./urgi_cluster/urgi_node3/elasticsearch-1.4.3 ./tribe_node/elasticsearch-1.4.3"

shutdown_es() {
	local PID_FILE=$1
	if [ ! -f "$PID_FILE" ];then
		echo "WARN: Cannot stop instance in $DIR since pid file does not exist."
		return
	fi
	local PID=`cat $PID_FILE`
	echo "INFO: Stopping instance with pid=$PID using PID file: $PID_FILE"
	kill -9 $PID
	rm -f $PID_FILE
}


for DIR in $INSTANCES;
	do
		shutdown_es "$DIR/$PID_FILE_NAME"
done
