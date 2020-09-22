drop table if exists Zips;

create table Zips
(
    Id int not null AUTO_INCREMENT primary key,
    CityAndState varchar(128) not null,
    Zip char(5) not null unique,
    City varchar(32) not null,
    State char(2) not null,
    Latitude double not null,
    Longitude double not null
);
