# Philly Tax Map

Parcel map showing 2015 property values

### Requirements

- Python
- Ruby
- [Postgresql](http://www.postgresql.org/)
- [Postgis](http://postgis.net/)
- [Tilemill](https://www.mapbox.com/tilemill/)

### Getting started

Install the Python ([virtualenv](http://virtualenv.readthedocs.org/en/latest/) is recommended) and Ruby requirements:

```bash
# Create a new virtualenv
$ virtualenv philly-tax-map
# Activate the virtualenv
$ ./philly-tax-map/bin/activate
# Python packages
$ pip install -r requirements.txt
# Ruby packages
$ gem bundle install
```

Then, to download the OPA and parcel data, setup the database, and generate map tiles, run:

```bash
$ make all
```

Note that this project was developed on OS X. You'll have to make some changes to how TileMill is invoked if you are using Linux. See The LA Times Data Desk Quiet-LA [project](https://github.com/datadesk/osm-quiet-la) for help.

### Preview app

```bash
$ bundle exec middleman server
```

### Build app

```bash
$ bundle exec middleman build
```
