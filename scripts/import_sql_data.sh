#!/bin/bash

echo "Create taxmap database..."
createdb taxmap

echo "Enable postgis..."
psql -d taxmap -c "CREATE EXTENSION postgis;"

echo "Import OPA and parcel data"
psql -d taxmap -f data/sql/create_opa_2014.sql
psql -d taxmap -f data/sql/create_opa_2015.sql
psql -d taxmap -f data/sql/import_opa_2014.sql
psql -d taxmap -f data/sql/import_opa_2015.sql
psql -d taxmap -f data/sql/import_parcels.sql

echo "Create parcel map table..."
psql -d taxmap -f create_tax_map_table.sql
