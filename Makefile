clean: 
	rm -r zip
	rm -r shp
	rm -r csv
	rm -r sql

all: sql/import_opa_2014.sql sql/import_opa_2015.sql sql/import_parcels.sql

zip/parcels.zip:
	mkdir -p zip
	curl -o zip/parcels.zip http://gis.phila.gov/gisdata/PARCELS_PWD.zip

zip/opa_2014.zip:
	mkdir -p zip
	curl -o zip/opa_2014.zip http://www.phila.gov/OPA/Documents/TaxYear2014DataSet.zip

zip/opa_2015.zip:
	mkdir -p zip
	curl -o zip/opa_2015.zip http://www.phila.gov/OPA/Documents/TaxYear2015DataSet.zip

shp/PARCELS_PWD.shp: zip/parcels.zip
	mkdir -p shp
	unzip zip/parcels.zip -d shp
	touch shp/PARCELS_PWD.shp

csv/opa_2014.csv: zip/opa_2014.zip
	mkdir -p csv
	unzip zip/opa_2014.zip -d csv
	mv csv/Tax\ Year\ 2014\ \ Download\ File/OPA\ 2014\ Certified\ Static\ Download\ File.txt csv/opa_2014.csv
	touch csv/opa_2014.csv

csv/opa_2015.csv: zip/opa_2015.zip
	mkdir -p csv
	unzip zip/opa_2015.zip -d csv
	mv csv/Tax\ Year\ 2015\ \ Download\ File/OPA\ 2015\ Certified\ Static\ Download\ File.txt csv/opa_2015.csv
	touch csv/opa_2015.csv

sql/import_parcels.sql: shp/PARCELS_PWD.shp
	mkdir -p sql
	shp2pgsql -s 4269 shp/PARCELS_PWD.shp public.parcels > sql/import_parcels.sql

sql/create_opa_2014.sql: csv/opa_2014.csv
	head -n 100 csv/opa_2014.csv | csvsql -i postgresql --no-constraints --table opa_2014 \
	  > sql/create_opa_2014.sql

sql/create_opa_2015.sql: csv/opa_2015.csv
	head -n 100 csv/opa_2015.csv | csvsql -i postgresql --no-constraints --table opa_2015 \
	  > sql/create_opa_2015.sql

sql/import_opa_2014.sql: sql/create_opa_2014.sql
	printf "COPY opa_2014 FROM '%s/csv/opa_2014.csv' WITH CSV HEADER;" $(shell pwd) > sql/import_opa_2014.sql

sql/import_opa_2015.sql: sql/create_opa_2015.sql
	printf "COPY opa_2015 FROM '%s/csv/opa_2015.csv' WITH CSV HEADER;" $(shell pwd) > sql/import_opa_2015.sql
