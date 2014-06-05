clean: 
	rm -r zip
	rm -r shp
	rm -r csv
	rm -r sql

all: scripts/import_opa_2014_data.sql scripts/import_opa_2015_data.sql scripts/create_and_import_parcels.sql

data/zip/parcels.zip:
	mkdir -p data/zip
	curl -o data/zip/parcels.zip http://gis.phila.gov/gisdata/PARCELS_PWD.zip

data/zip/opa_2014.zip:
	mkdir -p data/zip
	curl -o data/zip/opa_2014.zip http://www.phila.gov/OPA/Documents/TaxYear2014DataSet.zip

data/zip/opa_2015.zip:
	mkdir -p data/zip
	curl -o data/zip/opa_2015.zip http://www.phila.gov/OPA/Documents/TaxYear2015DataSet.zip

data/shp/PARCELS_PWD.shp: data/zip/parcels.zip
	mkdir -p data/shp
	unzip data/zip/parcels.zip -d data/shp
	touch data/shp/PARCELS_PWD.shp

data/csv/opa_2014.csv: data/zip/opa_2014.zip
	mkdir -p data/csv
	unzip data/zip/opa_2014.zip -d data/csv
	mv data/csv/Tax\ Year\ 2014\ \ Download\ File/OPA\ 2014\ Certified\ Static\ Download\ File.txt data/csv/opa_2014.csv
	touch data/csv/opa_2014.csv

data/csv/opa_2015.csv: data/zip/opa_2015.zip
	mkdir -p data/csv
	unzip data/zip/opa_2015.zip -d data/csv
	mv data/csv/Tax\ Year\ 2015\ \ Download\ File/OPA\ 2015\ Certified\ Static\ Download\ File.txt data/csv/opa_2015.csv
	touch data/csv/opa_2015.csv

scripts/create_and_import_parcels.sql: data/shp/PARCELS_PWD.shp
	shp2pgsql -s 4269 data/shp/PARCELS_PWD.shp public.parcels > scripts/create_and_import_parcels.sql

scripts/create_opa_2014_table.sql: data/csv/opa_2014.csv
	head -n 100 data/csv/opa_2014.csv | csvsql -i postgresql --no-constraints --table opa_2014 \
	  > scripts/create_opa_2014_table.sql

scripts/create_opa_2015_table.sql: data/csv/opa_2015.csv
	head -n 100 data/csv/opa_2015.csv | csvsql -i postgresql --no-constraints --table opa_2015 \
	  > scripts/create_opa_2015_table.sql

scripts/import_opa_2014_data.sql: scripts/create_opa_2014_table.sql
	printf "COPY opa_2014 FROM '%s/data/csv/opa_2014.csv' WITH CSV HEADER;" $(shell pwd) > scripts/import_opa_2014_data.sql

scripts/import_opa_2015_data.sql: scripts/create_opa_2015_table.sql
	printf "COPY opa_2015 FROM '%s/data/csv/opa_2015.csv' WITH CSV HEADER;" $(shell pwd) > scripts/import_opa_2015_data.sql
