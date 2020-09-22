delete from TruckstopHistorical;

LOAD DATA INFILE '/tmp/TruckstopHistorical-corrected.csv'
INTO TABLE TruckstopHistorical
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(   
    Company,
    Phone,
    Trlr,
    Age,
    Mode,
    Pickup,
    OriginCity,
    OriginState,
    Dist,
    DestinationCity, 
    DestinationState,
    Distance, 
    Rate,
    Length,
    Weight,
    D2p,
    Exp,
    Fuel,
    Miles );



--OPTIONALLY ENCLOSED BY '"'
