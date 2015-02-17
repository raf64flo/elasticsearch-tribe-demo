#!/bin/sh

echo "Starting each instance..."

PID_FILE_NAME="es.pid"

INSTANCES="./ebi_cluster/ebi_node_1/elasticsearch-1.4.3 ./ebi_cluster/ebi_node_2/elasticsearch-1.4.3 ./ebi_cluster/ebi_node_3/elasticsearch-1.4.3 ./urgi_cluster/urgi_node1/elasticsearch-1.4.3 ./urgi_cluster/urgi_node2/elasticsearch-1.4.3 ./urgi_cluster/urgi_node3/elasticsearch-1.4.3 ./tribe_node/elasticsearch-1.4.3"

check_error() {
	local CODE=$1
	local MESSAGE=$2
	if [ "$CODE" != 0 ]; then
		if [ -n "$MESSAGE" ]; then
			echo -e "ERROR: $MESSAGE"
		else 
			echo "ERROR: $CODE detected. Exiting."
		fi
		exit $CODE
	fi
}

startup_es() {
	local DIR="$1"
	local PID_FILE_NAME="$2"
	if [ -f "$DIR/$PID_FILE_NAME" ];then
		echo "WARN: PID file $DIR/$PID_FILE_NAME already exists, cannot start same instance twice... check process having PID = `cat $DIR/$PID_FILE_NAME`"
		return
	fi
	echo "INFO: Starting instance in $DIR..."
	$DIR/bin/elasticsearch -d -p $DIR/$PID_FILE_NAME
	check_error "$?" "Startup of instance in $DIR failed with error: $?"
	# echo "Starting instance in $DIR..."
	sleep 1
}

for DIR in $INSTANCES;
	do
	startup_es "$DIR" "$PID_FILE_NAME"
done
