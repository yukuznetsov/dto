delete from LaneTractorTypes;

LOAD DATA INFILE '/tmp/LaneTractorTypes-corrected.csv'
INTO TABLE LaneTractorTypes
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(   
    Origin,
    Dest,
    DestWslr,
    TractorType,
    LaneType,
    TrueTrip,
    Mileage
);

