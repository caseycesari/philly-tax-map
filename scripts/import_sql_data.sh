#!/bin/bash
createdb taxmap
psql -d taxmap -c "CREATE EXTENSION postgis;"

psql -d taxmap -f data/sql/create_opa_2014.sql
psql -d taxmap -f data/sql/create_opa_2015.sql
psql -d taxmap -f data/sql/import_opa_2014.sql
psql -d taxmap -f data/sql/import_opa_2015.sql
psql -d taxmap -f data/sql/import_parcels.sql
