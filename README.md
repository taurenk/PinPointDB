# PinPointDB
Scripts to build the PinPoint Geocoder database via US Census and Geonames data.

### Install PostgreSQL
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install postgresql
sudo apt-get install postgresql-9.3-postgis-9.2
sudo apt-get install lftp
sudo apt-get install unzip

### create user and database
sudo -u postgres psql postgres
\password postgres
crtl+d to exit
sudo -u postgres createdb pinpoint

### install postGIS package
sudo -u postgres psql postgres
CREATE EXTENSION postgis;

### install metaphone package
CREATE EXTENSION fuzzystrmatch;

### simple security setup...
set 'TRUST authentication' in ph_hba.conf
CHANGE: host    all         all         127.0.0.1/32          peer
TO: host    all         all         127.0.0.1/32          trust 

#### Allow pgadmin access: postgresql.cof
/etc/postgresql/9.3/main/postgresql.conf: listen_addresses = '*'

### Allow pgadmin access: pghba.conf
/etc/postgresql/9.3/main/pg_hba.conf:
ADD line to ipv6: host all all ip/24 md5

### Run ETL Script
sudo sh dataloader.sh
