


/* TODO: Add State column ETL */


/* Change all Street Names to Upper Case */
UPDATE addrfeat
	SET fullname = UPPER(fullname)

/* Add City Data to AddrFeat */
ALTER TABLE addrfeat
	ADD lcity VARCHAR(100) NULL,
	ADD rcity VARCHAR(100) NULL;

UPDATE addrfeat
	SET lcity = UPPER(place)
	FROM place
	WHERE addrfeat.zipl = place.zip

UPDATE addrfeat
	SET rcity = UPPER(place)
	FROM place
	WHERE addrfeat.zipr = place.zip	

/** Add Supporting Columns **/
ALTER TABLE addrfeat	
	ADD name 	VARCHAR(100) NULL,		-- Name without any modifiers
	ADD predirabrv	VARCHAR(15) NULL,	-- N,E,S,W
	ADD pretypabrv	VARCHAR(50) NULL,	-- I-, Co Rd, State Rte, US Hwy
	ADD suftypabrv	VARCHAR(50) NULL;	-- Ave,St,etc	-> have these stored.
	
/** Update Street Data **/
UPDATE addrfeat
	SET name 		= UPPER(feature.name), 		
		predirabrv = UPPER(feature.predirabrv),		
		pretypabrv = UPPER(feature.pretypabrv),	
		suftypabrv = UPPER(feature.suftypabrv)	
	FROM feature
	WHERE addrfeat.fullname = feature.fullname

/** Standardize into Caps **/
-- ex. Ave Of The Americas != Ave of the Americas....
UPDATE addrfeat
	SET name = UPPER(name)
	

-- Get Count [let's pray this is not too many]
SELECT COUNT(gid) FROM addrfeat WHERE name IS NULL 
SELECT fullname, name, zipl, zipr FROM addrfeat WHERE name IS NULL	