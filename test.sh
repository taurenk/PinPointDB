echo "*** PinPoint DB DataLoader ***"


# Create Directories
mkdir build
mkdir build/staging
mkdir build/unzipped

# Download Census Data
echo "Downloading Test Data for New York.. Please be Patient..."
lftp ftp2.census.gov << EOF
mirror -I "tl_2013_36*" /geo/tiger/TIGER2013/ADDRFEAT/ build/staging
mirror -I "tl_2013_36*" /geo/tiger/TIGER2013/FEATNAMES/ build/staging
quit 0
EOF



# Unzip Census Data
echo "Unzipping Data..."
count=0
for i in build/staging/*.zip; do
	unzip $i -d build/unzipped/
	count=$((count+1))
done
echo "Unzipped $count records."

# Create Table Structure [from  a downloaded file]
echo "Creating Table in Database..."
shp2pgsql -p build/unzipped/tl_2013_36001_addrfeat.shp addrfeat | psql -h localhost -U postgres -d pinpoint
shp2pgsql -p build/unzipped/tl_2013_36001_featnames feature | psql -h localhost -U postgres -d pinpoint

# Load Records into Database
echo "Loading Database..." 
for file in build/unzipped/*addrfeat.shp; do
	shp2pgsql -a $file addrfeat | psql -h localhost -U postgres -d pinpoint
done

for file in build/unzipped/*featnames.dbf; do
	shp2pgsql -n -a $file feature | psql -h localhost -U postgres -d pinpoint
done


# Load Place records
echo "Downloading and Loading Place Records..."
wget download.geonames.org/export/zip/US.zip
unzip US.zip
sudo -u postgres psql pinpoint -f place.sql
echo "Finished loading place data."


# run ETL stuff...
#echo "Running ETL Scripts..."
#sudo -u postgres psql pinpoint -f etl_script.sql

# TODO: create indexes.
echo "Finished Loading Data."

