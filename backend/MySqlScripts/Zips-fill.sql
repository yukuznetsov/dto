delete from Zips;

LOAD DATA INFILE '/tmp/Zips-corrected-short.csv'
INTO TABLE Zips
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(   
    CityAndState,
    Zip,
    City,
    State,
    Latitude,
    Longitude
);
