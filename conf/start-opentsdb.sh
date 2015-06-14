#!/bin/bash

if [ ! -e $TSDB/opentsdb_tables_created.txt ]; then
    echo "creating tsdb tables"
    bash $TSDB/create_tsdb_tables.sh
    echo "created tsdb tables"
fi

echo "starting opentsdb"
tsdb tsd --port=4242 --staticroot=$OPENTSDB_DIR/static --cachedir=/tmp --auto-metric --config=$OPENTSDB_DIR/etc/opentsdb.conf
