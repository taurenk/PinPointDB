SELECT gid, tlid, tfidl, tfidr, aridl, aridr, linearid, fullname, lfromhn, 
       ltohn, rfromhn, rtohn, zipl, zipr, edge_mtfcc, road_mtfcc, parityl, 
       parityr, plus4l, plus4r, lfromtyp, ltotyp, rfromtyp, rtotyp, 
       offsetl, offsetr, geom, streetname, streetphone, predirabrv, 
       suftypabrv
  FROM addrfeat;




SELECT * FROM feature limit 1000;

SELECT DISTINCT tlid FROM addrfeat;	-- 700, 411 
SELECT DISTINCT gid FROM addrfeat;	-- 950, 155 unique rows



-- RUN BACKUP ON ADDRFEAT table 
SELECT *
	INTO addrfeat_backup
	FROM addrfeat
	-- 950,155 Rows Backed UP
	
DROP TABLE addrfeat
SELECT * INTO addrfeat FROM addrfeat_backup
	
-- Metaphone ETL Function...
-- FUCK IT LETS GO LIVE 
ALTER TABLE addrfeat 
	ADD streetname varchar(100) NULL, 
	ADD streetphone varchar(50) NULL,  
	ADD predirabrv varchar(15)  NULL, 
	ADD pretypabrv varchar(50) NULL,
	ADD suftypabrv varchar(50)  NULL;

-- Update data from feature table
UPDATE addrfeat
	SET streetname = feature.name, 
		predirabrv = feature.predirabrv, 
		pretypabrv = feature.pretypabrv,
		suftypabrv = feature.suftypabrv  
	FROM feature
	WHERE addrfeat.streetname IS NULL
		AND addrfeat.fullname = feature.fullname
-- Check 
SELECT * 
	FROM addrfeat
	WHERE streetname IS NULL;
	-- 0 -> Queries Worked. Spot check some.
	
UPDATE addrfeat
	SET streetphone = metaphone(streetname, length(streetname) )
	-- 950,155 Rows Affected.
	
-- Spot Check
SELECT gid, tlid, fullname, streetname, streetphone, predirabrv, suftypabrv 
	FROM addrfeat
	ORDER BY gid
	LIMIT 200;

SELECT * FROM feature LIMIT 200;

