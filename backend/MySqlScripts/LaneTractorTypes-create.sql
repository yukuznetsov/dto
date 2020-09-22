drop table if exists LaneTractorTypes;

create table if not exists LaneTractorTypes
(
    Id int not null AUTO_INCREMENT primary key,
    Origin char(8) not null,
    Dest varchar(16) not null,
    DestWslr int not null,
    TractorType char(8) null,
    LaneType char(8) null,
    TrueTrip double null,
    Mileage double not null
);
