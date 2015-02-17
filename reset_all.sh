#!/bin/sh

echo "INFO: shutdown all"
./shutdown.sh > /dev/null

echo "INFO: removing all plugins"
./manage_plugins.sh remove head > /dev/null
./manage_plugins.sh remove marvel > /dev/null
./manage_plugins.sh remove solr > /dev/null

echo "INFO: reseting all data and logs..."
find . -name "data" -exec rm -rf {} \; > /dev/null
find . -name "logs" -exec rm -rf {} \; > /dev/null 2>&1

