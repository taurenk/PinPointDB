"""
Tauren Kristich
[].py
Automated Build Script to Build US Census database:
    1. Download [NY]data
    2. Unzip [NY] data
"""

import ftplib
import os
import zipfile
import psycopg2

def create_directories(dir_list):
    # Create Directories from list of locations
    for dir in dir_list:
        if not os.path.exists(dir): os.makedirs(dir)

def fetch_files(server, ftp_dir, dl_dir):
    """ Log into FTP Site, Go to target Directory
        And download all data inside.
    """
    count = 0 
    try:
        ftp = ftplib.FTP(server)
        ftp.login()
        print 'Connected to FTP: %s' % server
        ftp.cwd(ftp_dir)
        for file in ftp.nlst():
            # Download only NY State Data
            if 'tl_2013_36' in file:
                ftp.retrbinary('RETR %s' % file, open(dl_dir+'/'+file, 'wb').write )
                count += 1
        ftp.quit()  
    except: 
        print 'Error Retrieving data'
    print 'Downloaded %s files' % count     

def unzip_data(from_dir, to_dir):
    # Unzip ShapeFile
    count = 0
    try:
        for file in os.listdir(from_dir):
            file = os.path.abspath(from_dir+'/'+file)
            with zipfile.ZipFile(file) as z:
                z.extractall(to_dir + '/')
                count += 1
    except Exception as ex:
        print 'Error: %s' % ex 
    print 'Unzipped %s files' % count

def main():
    print '*** PinpPoint Geocoder ***'
    print 'Starting U.S. Census build script...'

    ftp_server = 'ftp2.census.gov'
    ftp_dir = [ 'geo/tiger/TIGER2013/EDGES/', 
                    'geo/tiger/TIGER2013/ADDR/',
                    'geo/tiger/TIGER2013/FEATNAMES/' ]
    zip_dir = ['build/zips/edges', 'build/zips/addr', 'build/zips/feats']
    staging_dir =  ['build/staging/edges', 'build/staging/addr', 'build/staging/feats']
    create_directories(zip_dir)
    create_directories(staging_dir)
    index = 0
    for dir in ftp_dir:
        print 'Current Directory: %s' % dir
        fetch_files(ftp_server, dir, zip_dir[index])
        unzip_data(zip_dir[index], staging_dir[index])
        index += 1
    
if __name__ == '__main__':
    main()