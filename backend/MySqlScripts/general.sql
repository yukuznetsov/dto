MySql:
a12Bo873


delimiter $$
drop procedure if exists SP_GetMarketFreight;
create procedure SP_GetMarketFreight( par_Extension bit )
begin
    if par_Extension = 1 then
        select 
            row_number() over (order by th.Pickup asc ) as Id,
            th.Id as TruckStopId,
            
            SF_EscapeString( th.OriginCity ) as OriginCity,
            UPPER( th.OriginState ) as OriginState,
            StartCc.Latitude as OriginLatitude,
            StartCc.Longitude as OriginLongitude,
            
            SF_EscapeString( th.DestinationCity ) as DestinationCity,
            UPPER( th.DestinationState ) as DestinationState,
            FinishCc.Latitude as DestinationLatitude,
            FinishCc.Longitude as DestinationLongitude,
            
            th.Pickup as PickupDate,
            NULL as LastDeliveryDate,
            IFNULL( th.Rate, th.Miles * 2.5 ) as Rate,
            IF( th.Rate is not null, 1, 0 ) as IsRateOriginal
        from
            TruckstopHistorical as th
            inner join VW_CityCoords as  StartCc on StartCc.City = TRIM(UPPER(th.OriginCity)) and StartCc.State = TRIM(UPPER(th.OriginState))
            inner join VW_CityCoords as  FinishCc on FinishCc.City = TRIM(UPPER(th.DestinationCity)) and FinishCc.State = TRIM(UPPER(th.DestinationState))
        where 
            th.OriginState = "TX" and
            th.DestinationState = "TX" and
            (th.Rate is not null or th.Miles is not null);
    else
        select 
            row_number() over (order by th.Pickup asc ) as Id,
            th.Id as TruckStopId,
            
            SF_EscapeString( th.OriginCity ) as OriginCity,
            UPPER( th.OriginState ) as OriginState,
            StartCc.Latitude as OriginLatitude,
            StartCc.Longitude as OriginLongitude,
            
            SF_EscapeString( th.DestinationCity ) as DestinationCity,
            UPPER( th.DestinationState ) as DestinationState,
            FinishCc.Latitude as DestinationLatitude,
            FinishCc.Longitude as DestinationLongitude,
            
            th.Pickup as PickupDate,
            NULL as LastDeliveryDate,
            th.Rate as Rate
        from
            TruckstopHistorical as th
            inner join VW_CityCoords as  StartCc on StartCc.City = TRIM(UPPER(th.OriginCity)) and StartCc.State = TRIM(UPPER(th.OriginState))
            inner join VW_CityCoords as  FinishCc on FinishCc.City = TRIM(UPPER(th.DestinationCity)) and FinishCc.State = TRIM(UPPER(th.DestinationState))
        where 
            th.Trlr = "V" and
            th.Rate is not null and
            th.OriginState = "TX" and
            th.DestinationState = "TX";
    end if;
end $$
delimiter ;



delimiter $$
drop procedure if exists SP_GetMarketFreight_Ext;
create procedure SP_GetMarketFreight_Ext()
begin
    select 
        row_number() over (order by th.Pickup asc ) as Id,
        th.Id as TruckStopId,
        
        SF_EscapeString( th.OriginCity ) as OriginCity,
        UPPER( th.OriginState ) as OriginState,
        StartCc.Latitude as OriginLatitude,
        StartCc.Longitude as OriginLongitude,
        
        SF_EscapeString( th.DestinationCity ) as DestinationCity,
        UPPER( th.DestinationState ) as DestinationState,
        FinishCc.Latitude as DestinationLatitude,
        FinishCc.Longitude as DestinationLongitude,
        
        th.Pickup as PickupDate,
        NULL as LastDeliveryDate,
        IFNULL( th.Rate, th.Miles * 2.5 ) as Rate
    from
        TruckstopHistorical as th
        inner join VW_CityCoords as  StartCc on StartCc.City = TRIM(UPPER(th.OriginCity)) and StartCc.State = TRIM(UPPER(th.OriginState))
        inner join VW_CityCoords as  FinishCc on FinishCc.City = TRIM(UPPER(th.DestinationCity)) and FinishCc.State = TRIM(UPPER(th.DestinationState))
    where 
        th.OriginState = "TX" and
        th.DestinationState = "TX" and
        (th.Rate is not null or th.Miles is not null )
end $$
delimiter ;


-- call SP_GetMarketFreight();




-- call SP_FillBackhaulsSummary();





delimiter $$
drop procedure SP_DistributeDates $$
create procedure SP_DistributeDates( par_FirstDay date, par_LastDay date, par_DayCount int, par_Hour time )
begin
    declare IntervalDayCount int;
    declare Cnt int;
    declare DayNumber int;
    declare TheDay date;

    if par_DayCount <= 0 or par_DayCount is null then
        SIGNAL SQLSTATE '22012'
        SET MESSAGE_TEXT = 'Wrong par_DayCount';
    end if;

    if par_FirstDay > par_LastDay then
        SIGNAL SQLSTATE '22012'
        SET MESSAGE_TEXT = 'Wrong Date Interval';
    end if;


    
    set IntervalDayCount = datediff( par_LastDay, par_FirstDay ) + 1;
    
    
    create temporary table if not exists TT_Days
    (
        TheDateTime datetime not null
    );
    delete from TT_Days;

    set Cnt = 0;
    while Cnt < par_DayCount do
        set DayNumber = floor( rand() * IntervalDayCount );
        set TheDay = date_add( par_FirstDay, interval DayNumber DAY );

        insert into TT_Days ( TheDateTime ) value ( ADDTIME( CONVERT(TheDay, datetime), par_Hour ) );
        set Cnt = Cnt + 1;
    end while;
end $$
delimiter ;

-- call SP_DistributeDates( '2020-07-20', '2020-07-29', 3, '09:00:00' );


delimiter $$
drop procedure if exists SP_Test;
create procedure SP_Test( par_FirstDay date, par_LastDay date )
begin
    DECLARE finished INTEGER DEFAULT 0;
    


    
    declare cur_BackhaulSumm cursor for
    select
        BackhaulSummaryId, 
        DedLoadsToFill
    from
        TT_BackhaulsSummary;
        
    DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;    
        
        
    if finished > 0 then
        set finished = 1;
    end if;
        
end $$
delimiter ;


        
delimiter $$
drop procedure if exists SP_FillBackhaulsSummary;
create procedure SP_FillBackhaulsSummary()
begin

    drop temporary table if exists TT_BackhaulsSummary;
    create temporary table TT_BackhaulsSummary
    (
        BackhaulSummaryId int not null,
    
        OriginCity varchar(64) not null,
        OriginState char(2) not null,
        OriginType  char(8) not null,
        OriginLatitude double null,
        OriginLongitude double null,
        OriginWslr int null,
        
        DestinationCity varchar(64) not null,
        DestinationState char(2) not null,
        DestinationType  char(8) not null,
        DestinationLatitude double null,
        DestinationLongitude double null,
        DestinationWslr int null,
        
        TotalLoadsToFill int null,
        DedLoadsToFill int null,
        TruckType char(8) null
    );
    
    insert into 
        TT_BackhaulsSummary
    with 
        WslrToGeo as (
            select 
                Wslr_Zip.Wslr as Wslr,
                Zips.Latitude as Latitude,
                Zips.Longitude as Longitude
            from
                Wslr_Zip
                inner join Zips on Wslr_Zip.Zip = Zips.Zip )
    select 
        bd.Id as BackhaulSummaryId,
        
        bd.OriginCity as OriginCity,
        bd.OriginState as OriginState,
        bd.OriginType as OriginType,
        OriginGeo.Latitude as OriginLatitude,
        OriginGeo.Longitude as OriginLongitude,
        OriginGeo.Wslr as OriginWslr,
        
        bd.DestinationCity as DestinationCity,
        bd.DestinationState as DestinationState,
        bd.DestinationType as DestinationType,
        DestGeo.Latitude as DestinationLatitude,
        DestGeo.Longitude as DestinationLongitude,
        DestGeo.Wslr as DestinationWslr,
        
        bd.TotalLoadsToFill as TotalLoadsToFill,
        bd.DedicatedLoadsToFill as DedLoadsToFill,
        tt.LaneType as TruckType
    from 
        BackhaulData as bd
        left outer join WslrToGeo as OriginGeo on bd.OriginWslr = OriginGeo.Wslr
        left outer join WslrToGeo as DestGeo on bd.DestinationWslr = DestGeo.Wslr
        left outer join LaneTractorTypes as tt on bd.Lane = concat( tt.Origin, "_", tt.Dest )
    order by 
        bd.Id asc;

end $$
delimiter ;
        


delimiter $$
drop procedure if exists SP_ModelBackhauls;
create procedure SP_ModelBackhauls( par_FirstDay date, par_LastDay date )
begin
    declare LocalId int;
    declare LoadsCount int;
    declare IntervalDayCount int;
    declare DaysPerInterval double;
    declare DaysPerIntervalInt int;
    DECLARE finished INTEGER DEFAULT 0;
    declare MorningHour time default '09:00:00';
    declare HorizonInDays int default 12;

    
    
    declare cur_BackhaulSumm cursor for
    select
        BackhaulSummaryId, 
        DedLoadsToFill
    from
        TT_BackhaulsSummary
    order by 
        BackhaulSummaryId asc;
        
    DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;    

    drop temporary table if exists TT_Backhauls;
    create temporary table TT_Backhauls
    (
        Id int not null AUTO_INCREMENT primary key,
        BackhaulSummaryId int not null,
    
        OriginCity varchar(64) not null,
        OriginState char(2) not null,
        OriginType  char(8) not null,
        OriginLatitude double null,
        OriginLongitude double null,
        OriginWslr int null,
        
        DestinationCity varchar(64) not null,
        DestinationState char(2) not null,
        DestinationType  char(8) not null,
        DestinationLatitude double null,
        DestinationLongitude double null,
        DestinationWslr int null,
        
        EarlyStart datetime not null,
        LateFinish datetime not null,
        
        TruckType char(8) null
    );
    
        
    if par_FirstDay > par_LastDay then
        SIGNAL SQLSTATE '22012'
        SET MESSAGE_TEXT = 'Wrong Date Interval';
    end if;
        
        
    set IntervalDayCount = datediff( par_LastDay, par_FirstDay ) + 1;

        
    call SP_FillBackhaulsSummary();
    open cur_BackhaulSumm;

    
    lbl: loop 

        fetch cur_BackhaulSumm into LocalId, LoadsCount;


        IF finished = 1 THEN 
            LEAVE lbl;
        END IF;

        set DaysPerInterval = convert(IntervalDayCount, double) * (convert(LoadsCount, double) / 365.0);
        
        if DaysPerInterval >= 1.0 then
            set DaysPerIntervalInt = round(DaysPerInterval);
        else
            if rand() < DaysPerInterval then
                set DaysPerIntervalInt = 1;
            else
                set DaysPerIntervalInt = 0;
            end if;
        end if;
        
        

        if DaysPerIntervalInt > 0 then
            call SP_DistributeDates( par_FirstDay, par_LastDay, DaysPerIntervalInt, MorningHour );

            insert into 
                TT_Backhauls(
                    BackhaulSummaryId,
                    OriginCity,
                    OriginState,
                    OriginType,
                    OriginLatitude,
                    OriginLongitude,
                    OriginWslr,
                    DestinationCity,
                    DestinationState,
                    DestinationType,
                    DestinationLatitude,
                    DestinationLongitude,
                    DestinationWslr,
                    EarlyStart,
                    LateFinish,
                    TruckType )
            select
                bs.BackhaulSummaryId,
                SF_EscapeString( bs.OriginCity ) as OriginCity,
                UPPER( bs.OriginState ) as OriginState,
                bs.OriginType,
                bs.OriginLatitude,
                bs.OriginLongitude,
                bs.OriginWslr,
                SF_EscapeString( bs.DestinationCity ) as DestinationCity,
                UPPER( bs.DestinationState ) as DestinationState,
                bs.DestinationType,
                bs.DestinationLatitude,
                bs.DestinationLongitude,
                bs.DestinationWslr,
                TT_Days.TheDateTime as EarlyStart,
                date_add( TT_Days.TheDateTime, interval HorizonInDays day ) as LateFinish,
                bs.TruckType
            from
                TT_BackhaulsSummary as bs
                cross join TT_Days
            where
                bs.BackhaulSummaryId = LocalId;

        end if;


        
    end loop lbl;
    
    close cur_BackhaulSumm;

    select 
        * 
    from 
        TT_Backhauls 
    where 
        OriginState = 'TX' and 
        DestinationState = 'TX' and 
        OriginLatitude is not null and 
        OriginLongitude is not null and 
        DestinationLatitude is not null and 
        DestinationLongitude is not null 
    order by 
        BackhaulSummaryId asc, EarlyStart asc;

end $$
delimiter ;



-- call SP_ModelBackhauls( '2020-07-01', '2020-07-10' );




mysql --user=root --password=a12Bo873 -D Dto -e "call SP_ModelBackhauls( '2020-06-30', '2020-06-30' );" > _backhauls_.csv
mysql --user=root --password=a12Bo873 -D Dto -e "call SP_GetMarketFreight( 1 );" > _market_.csv







drop view VW_CityCoords;
create view 
    VW_CityCoords
as
    with
        SelectedLocations as (
            select 
                City, State, min(Id) as MinId
            from
                Zips
            group by 
                City, State )
    select 
        TRIM(UPPER(Zips.City)) as City,
        TRIM(UPPER(Zips.State)) as State,
        Zips.Latitude,
        Zips.Longitude
    from
        Zips 
        inner join SelectedLocations as sl on sl.MinId = Zips.Id;
    

    
-------------
    

    
    
    
    

select 
    Id 
from 
    TruckstopHistorical 
    inner join VW_CityCoords on UPPER(VW_CityCoords.City) = UPPER(TruckstopHistorical.OriginCity)
limit 3;



if " GRAND PRAIRIE"






delimiter $$
drop function if exists SF_EscapeString;
create function SF_EscapeString( par_String varchar(16000) )
returns varchar(16000)
DETERMINISTIC
begin
    declare EscapedString varchar(16000);
    
    
    set EscapedString = REGEXP_REPLACE( par_String, "(^[^0-9a-zA-Z_]+|[^0-9a-zA-Z_]+$)", "" );
    set EscapedString = REGEXP_REPLACE( EscapedString, "[^0-9a-zA-Z_]", "_" );
    set EscapedString = UPPER( EscapedString );
    
    return EscapedString;

end $$
delimiter ;


















