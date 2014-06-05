#!/bin/bash

echo "Create taxmap database..."
createdb taxmap

echo "Enable postgis..."
psql -d taxmap -c "CREATE EXTENSION postgis;"

echo "Import OPA and parcel data"
psql -d taxmap -f create_opa_2014_table.sql
psql -d taxmap -f create_opa_2015_table.sql
psql -d taxmap -f import_opa_2014_data.sql
psql -d taxmap -f import_opa_2015_data.sql
psql -d taxmap -f create_and_import_parcels.sql

echo "Create parcel map table..."
psql -d taxmap -f create_tax_map_table.sql
