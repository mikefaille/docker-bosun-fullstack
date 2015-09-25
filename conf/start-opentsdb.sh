#!/bin/bash
#Source : https://github.com/PeterGrace/opentsdb-docker/blob/master/start_opentsdb.sh#L2
echo "Sleeping for 30 seconds to give HBase time to warm up"
sleep 30
stopwaitsecs=60

if [ ! -e /data/persistant/opentsdb_tables_created.txt ]; then
    echo "creating tsdb tables"
    bash /data/create_tsdb_tables.sh
    echo "created tsdb tables"
fi

echo "starting opentsdb"
$TSDB/build/tsdb tsd --port=4242 --staticroot=$TSDB/build/staticroot --cachedir=/tmp --auto-metric --config=$TSDB/opentsdb.conf
#tsdb tsd --port=4242 --staticroot=$OPENTSDB_DIR/static --cachedir=/tmp --auto-metric --config=$OPENTSDB_DIR/etc/opentsdb/opentsdb.conf
