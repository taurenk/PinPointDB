#!/bin/bash
# RUN dos to *nix on this...
echo ***** Pinpoint Data Loader *****
echo Creating Table Structures...
shp2pgsql -p build/staging/edges/tl_2013_36001_edges.shp edge | psql -h localhost -U postgres -d pinpoint
shp2pgsql -p build/staging/addr/tl_2013_36001_addr range | psql -h localhost -U postgres -d pinpoint
shp2pgsql -p build/staging/feats/tl_2013_36001_featnames feature | psql -h localhost -U postgres -d pinpoint 
echo Finished.

echo Loading Edge Data...
count = 0
for i in build/staging/edges/*.shp; do
	shp2pgsql -a $i edge | psql -h localhost -U postgres -d pinpoint
	((count=count+1))
done
echo Loaded $count Edge records.

echo Loading Range Data...
count = 0
for i in build/staging/addr/*.dbf; do
	shp2pgsql -a $i range | psql -h localhost -U postgres -d pinpoint
	((count=count+1))
done
echo Loaded $count Range records.

echo Loading Feature Data...
count = 0
for i in build/staging/feats/*.dbf; do
	shp2pgsql -a $i feature | psql -h localhost -U postgres -d pinpoint
	((count=count+1))
done
echo Loaded $count Feature records.

echo Finished Loading Data!
