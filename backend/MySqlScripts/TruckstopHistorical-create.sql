drop table if exists TruckstopHistorical;

create table if not exists TruckstopHistorical
(
    Id int not null AUTO_INCREMENT primary key,
    Company varchar(16) not null,
    Phone char(12) not null,
    Trlr char(4) not null,
    Age char(5) not null,
    Mode char(5) not null,
    Pickup char(6) not null,
    OriginCity varchar(32) not null,
    OriginState char(2) not null,
    Dist int not null,
    DestinationCity varchar(32) not null, 
    DestinationState char(2) not null,
    Distance int not null, 
    Rate int null,
    Length int null,
    Weight int null,
    D2p char(12) null,
    Exp char(1) not null,
    Fuel int not null,
    Miles int not null
);
