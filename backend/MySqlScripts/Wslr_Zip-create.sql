drop table if exists Wslr_Zip;
create table Wslr_Zip
(
    Id int not null AUTO_INCREMENT primary key,
    Wslr int not null unique,
    Name varchar(128) not null,
    City  varchar(128) null,
    State char(2) not null,
    Address varchar(256) null,
    Zip char(16) null
);
