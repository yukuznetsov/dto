delete from Wslr_Zip;

LOAD DATA INFILE '/tmp/Wslr_Zip-corrected.csv'
INTO TABLE Wslr_Zip
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(   
    Wslr,
    Name,
    City, 
    State,
    Address,
    Zip
);
