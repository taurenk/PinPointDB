echo **** PinPoint Geocoder ****
echo  *** Database Builder ***
echo Retrieving U.S. zip data
wget download.geonames.org/export/zip/US.zip
echo unpacking....
unzip US.zip
echo unpacked.
echo Building place schema and loading data...
sudo -u postgres psql pinpoint -f place.sql
echo Finished.
