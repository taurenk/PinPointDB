

CREATE TABLE place (iso_code varchar, 
                        zip varchar,
                        place varchar,
                        name1 varchar,
                        code1 varchar,
                        name2 varchar,
                        code2 varchar,
                        name3 varchar,
                        code3 varchar,
                        latitude float, 
                        longitude float,
                    	accuracy varchar
                    );

\COPY place FROM 'US.txt';