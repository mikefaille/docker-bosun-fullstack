#!/bin/bash
#Source : https://github.com/PeterGrace/opentsdb-docker/blob/master/start_opentsdb.sh#L2
echo "Sleeping for 30 seconds to give HBase time to warm up"
stopwaitsecs=60

if [ ! -e $TSDB/opentsdb_tables_created.txt ]; then
    echo "creating tsdb tables"
    bash $TSDB/create_tsdb_tables.sh
    echo "created tsdb tables"
fi

echo "starting opentsdb"
tsdb tsd --port=4242 --staticroot=$OPENTSDB_DIR/static --cachedir=/tmp --auto-metric --config=$OPENTSDB_DIR/etc/opentsdb/opentsdb.conf
