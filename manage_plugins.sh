#!/bin/sh

ACTION="$1"
PLUGIN="$2"

usage() {
	echo -e "USAGE:\n\t $0 <install|remove> <marvel|head|solr>"
	echo -e "EXAMPLE:\n\t $0 install head"
	exit 1
}

# PLUGINS="es.pid"

INSTANCES="./ebi_cluster/ebi_node_1/elasticsearch-1.4.3 ./ebi_cluster/ebi_node_2/elasticsearch-1.4.3 ./ebi_cluster/ebi_node_3/elasticsearch-1.4.3 ./urgi_cluster/urgi_node1/elasticsearch-1.4.3 ./urgi_cluster/urgi_node2/elasticsearch-1.4.3 ./urgi_cluster/urgi_node3/elasticsearch-1.4.3"
# ./tribe_node/elasticsearch-1.4.3
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

remove_plugin() {
	local DIR="$1"
	local PLUGIN_DIR="$2"
	local PLUGIN_REMOVE_CMD="$3"
	local PLUGIN="$4"
	local PLUGIN_INSTALL_DIR="$DIR/$PLUGIN_DIR"
	if [ ! -d "$PLUGIN_INSTALL_DIR" ];then
		echo "WARN: $PLUGIN seems to not be installed in $PLUGIN_INSTALL_DIR, skipping..."
		return
	fi
	echo "INFO: Removing $PLUGIN plugin for instance in $DIR..."
	$DIR/bin/plugin $PLUGIN_REMOVE_CMD
	check_error "$?"
	# sleep 1
}

install_plugin() {
	local DIR="$1"
	local PLUGIN_DIR="$2"
	local PLUGIN_INSTALL_CMD="$3"
	local PLUGIN="$4"
	local PLUGIN_INSTALL_DIR="$DIR/$PLUGIN_DIR"
	if [ -d "$PLUGIN_INSTALL_DIR" ];then
		echo "WARN: $PLUGIN seems to be already installed in $PLUGIN_INSTALL_DIR, skipping..."
		return
	fi
	echo "INFO: Installing $PLUGIN plugin for instance in $DIR..."
	$DIR/bin/plugin $PLUGIN_INSTALL_CMD
	check_error "$?"
	# sleep 1
}


# check parameters
if [ "$#" -ne 2 ];then
	echo "ERROR: missing parameters."
	usage
	exit 1
fi

# check plugins
if [ "$PLUGIN" == "head" ];then
	PLUGIN_DIR="plugins/head"
	PLUGIN_INSTALL_CMD="--install mobz/elasticsearch-head"
	PLUGIN_REMOVE_CMD="--remove mobz/elasticsearch-head"
elif [ "$PLUGIN" == "marvel" ];then
	PLUGIN_DIR="plugins/marvel"
	PLUGIN_INSTALL_CMD="--install elasticsearch/marvel/latest"
	PLUGIN_REMOVE_CMD="--remove elasticsearch/marvel/latest"
elif [ "$PLUGIN" == "solr" ];then
	PLUGIN_DIR="plugins/river-solr"
	PLUGIN_INSTALL_CMD="install river-solr --url http://bit.ly/1qzA7lB"
	PLUGIN_REMOVE_CMD="--remove river-solr"
else
	echo "ERROR: unknown plugin: $PLUGIN"
	usage
fi

for DIR in $INSTANCES;do
	if [ "$ACTION" == "install" ]
		then
		install_plugin "$DIR" "$PLUGIN_DIR" "$PLUGIN_INSTALL_CMD" "$PLUGIN"
	elif [ "$ACTION" == "remove" ]
		then
		remove_plugin "$DIR" "$PLUGIN_DIR" "$PLUGIN_REMOVE_CMD" "$PLUGIN"
	else
		echo "ERROR: unknown action: $ACTION"
		usage
	fi
done


