# Philly Tax Map

Parcel map showing 2015 property values

### Requirements

- Python
- [csvkit](https://github.com/onyxfish/csvkit)
- [psycopg2]()
- [Postgresql](http://www.postgresql.org/) and [Postgis](http://postgis.net/)
- [Tilemill](https://www.mapbox.com/tilemill/)
- [middleman](http://middlemanapp.com/)

### Setup

    $ cd path/to/philly-tax-map/data
    $ make all
    $ cd .. && ./scripts/import_sql_data.sh
