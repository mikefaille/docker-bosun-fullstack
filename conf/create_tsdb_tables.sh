#!/bin/bash

cd $TSDB
./src/create_table.sh
touch $TSDB/opentsdb_tables_created.txt
