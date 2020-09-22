drop table if exists BackhaulData;
create table BackhaulData
(
    Id int not null AUTO_INCREMENT primary key,
    Original int not null,
    BreweryGroup char(8) not null,
    Lane varchar(32) not null,
    Origin char(8) not null,
    OriginWslr int not null,
    OriginCity varchar(64) not null,
    OriginState char(2) not null, 
    OriginType char(8) not null,
    Destination char(8) not null,
    DestinationWslr int not null, 
    DestinationCity varchar(64) not null,
    DestinationState char(2) not null,
    DestinationType  char(8) not null,
    OW_Miles int not null,
    TR_Loads int not null,
    BH_Loads int not null,
    tgt_ded_pcnt int not null,
    bbls int not null,
    ActDedicatedPayload int not null,
    DedicatedLoads int null,
    Loads int not null,
    FilledLoads int null,
    TotalLoadsToFill int null,
    DedicatedLoadsToFill int null
);
