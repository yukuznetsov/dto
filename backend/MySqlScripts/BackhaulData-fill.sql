delete from BackhaulData;

LOAD DATA INFILE '/tmp/BackhaulData-corrected.csv'
INTO TABLE BackhaulData
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(   
    Original,
    BreweryGroup,
    Lane,
    Origin,
    OriginWslr,
    OriginCity,
    OriginState, 
    OriginType,
    Destination,
    DestinationWslr, 
    DestinationCity,
    DestinationState,
    DestinationType,
    OW_Miles,
    TR_Loads,
    BH_Loads,
    tgt_ded_pcnt,
    bbls,
    ActDedicatedPayload,
    DedicatedLoads,
    Loads,
    FilledLoads,
    TotalLoadsToFill,
    DedicatedLoadsToFill
);    
