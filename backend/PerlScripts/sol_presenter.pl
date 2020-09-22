#!/usr/bin/perl
use lib '/home/ykuznetsov/Converters/';

use warnings;
use strict;
use clCommandLine;
use clGvrpTask;
use clGvrpSolution;


use Data::Dumper;
use XML::LibXML; 
use Scalar::Util qw(blessed);

# perl -MXML::LibXML -le 'print $INC{"XML/LibXML.pm"}'

use constant INNER_PICKUP_SUFF => 'ip-';
use constant INNER_DELIVERY_SUFF => 'id-';
use constant EXTRA_PICKUP_SUFF => 'ep-';
use constant EXTRA_DELIVERY_SUFF => 'ed-';
use constant TERMINAL_SUFF => 'Terminal_';





sub PrintWaypointData
{
    my ($wayp, $pref) = @_;
    
    $pref //= '';

    if( !defined($wayp) )
    {
        print "${pref}order;${pref}arrive;${pref}depart;${pref}dist";
    }
    elsif( !ref($wayp) && $wayp eq 'empty' )
    {
        print ";;;";
    }
    else
    {
        die unless( defined($wayp) && blessed($wayp) && $wayp->isa('clGvrpSolution::Waypoint') );
        print $wayp->getOrder() . ';' . $wayp->getArrive() . ';' . $wayp->getDepart() . ';' . $wayp->getDist();
    }
}

sub PrintVehicleData
{
    my ($VehName, $IpWaypoint, $IdWaypoint, $EpWaypoint, $EdWaypoint, $TermWaypoint) = @_;
    
    if( !defined($VehName) )
    {
        print 'veh_name;';
        PrintWaypointData( undef, 'ip-' );
        print ';';
        PrintWaypointData( undef, 'id-' );
        print ';';
        PrintWaypointData( undef, 'ep-' );
        print ';';
        PrintWaypointData( undef, 'ed-' );
        print ';';
        PrintWaypointData( undef, 'term-' );
    }
    else
    {
        die if( ref($VehName) );
        
        print "$VehName;";        
        foreach my $wp ($IpWaypoint, $IdWaypoint, $EpWaypoint, $EdWaypoint, $TermWaypoint)
        {
            if( defined($wp) )
            {
                die unless( blessed($wp) && $wp->isa('clGvrpSolution::Waypoint') );
                PrintWaypointData( $wp );
                print ';';
            }
            else
            {
                PrintWaypointData( 'empty' );
                print ';';
            }
        }
    }
}



sub PresentSolution
{
    my $Sol = shift @_;
    die unless( defined($Sol) && blessed($Sol) && $Sol->isa('clGvrpSolution') );
    
    PrintVehicleData( undef );
    print "\n";
    
    foreach my  $I (0 .. ($Sol->getRouteCount() - 1))
    {
        my $Route = $Sol->getRouteByI( $I );
        die unless( defined($Route) && blessed($Route) && $Route->isa('clGvrpSolution::Route') );
        
        my $VehName = $Route->getVehicle();
        
       
        my $Terminal;
        my @Waypoints;
        
        $Terminal = $Route->getTerminal();
        die unless( defined($Terminal) && blessed($Terminal) && $Terminal->isa('clGvrpSolution::Terminal') );
        foreach my $J (0 .. ($Route->getWaypointCount() - 1))
        {
            my $Waypoint = $Route->getWaypointByI( $J );
            die unless( defined($Waypoint) && blessed($Waypoint) && $Waypoint->isa('clGvrpSolution::Waypoint') );
            
            push @Waypoints, $Waypoint;
        }
            
 
        my $IpWaypoint = undef;
        my $IdWaypoint = undef;
        my $EpWaypoint = undef;
        my $EdWaypoint = undef;
        my $TermWaypoint = undef;
        
        if( clCommandLine::GetValue( '-no-term' ) )
        {
            die unless( scalar(@Waypoints) == 4 || scalar(@Waypoints) == 2 );
            
            if( scalar(@Waypoints) == 2 )
            {
                $IpWaypoint = $Waypoints[ 0 ];
                $IdWaypoint = $Waypoints[ 1 ];
            
                die unless( $IpWaypoint->getOrder() =~ m/${\INNER_PICKUP_SUFF}/ );
                die unless( $IdWaypoint->getOrder() =~ m/${\INNER_DELIVERY_SUFF}/ );
            }
            elsif( scalar(@Waypoints) == 4 )
            {
                $IpWaypoint = $Waypoints[ 0 ];
                $IdWaypoint = $Waypoints[ 1 ];
                $EpWaypoint = $Waypoints[ 2 ];
                $EdWaypoint = $Waypoints[ 3 ];
            
                die unless( $IpWaypoint->getOrder() =~ m/${\INNER_PICKUP_SUFF}/ );
                die unless( $IdWaypoint->getOrder() =~ m/${\INNER_DELIVERY_SUFF}/ );
                die unless( $EpWaypoint->getOrder() =~ m/${\EXTRA_PICKUP_SUFF}/ );
                die unless( $EdWaypoint->getOrder() =~ m/${\EXTRA_DELIVERY_SUFF}/ );
            }
            else
            {
                die;
            }
            
            #    my $_key_arrives = 'arrives';       # required, time of 'arrival', rast time
            #    my $_key_departs = 'departs';       # required, time of 'departure', rast time
            #    my $_key_dist = 'arc_dist';         # required, the distance of this arc, integer
            #    my $_key_order = 'order'; # required, scalar (secure string)    
            #    my $_key_Latitudes = 'arc_latitudes';       # optional, latitudes of this arc, ref to an array
            #    my $_key_Longitudes = 'arc_longitudes';     # optional, longitudes of this arc, ref to an array
            
            my $ArriveToTermop_Seconds = clTime::ConvertRastTimeToSeconds( $Terminal->getArrive() ) - 5 * 60;
            $TermWaypoint = clGvrpSolution::Waypoint->New( {
                'arrives' => clTime::ConvertSecondsToRastTimeMultyHours( $ArriveToTermop_Seconds ),
                'departs' => $Terminal->getArrive(),
                'arc_dist' => $Terminal->getDist(),
                'order' => 'virtual_termop' } );
        }
        else
        {
            die unless( scalar(@Waypoints) == 5 || scalar(@Waypoints) == 3 );
            
            if( scalar(@Waypoints) == 3 )
            {
                $IpWaypoint = $Waypoints[ 0 ];
                $IdWaypoint = $Waypoints[ 1 ];
                $TermWaypoint = $Waypoints[ 2 ];
                
                die unless( $IpWaypoint->getOrder() =~ m/${\INNER_PICKUP_SUFF}/ );
                die unless( $IdWaypoint->getOrder() =~ m/${\INNER_DELIVERY_SUFF}/ );
                die unless( $TermWaypoint->getOrder() =~ m/${\TERMINAL_SUFF}/ );
            }
            elsif( scalar(@Waypoints) == 5 )
            {
                $IpWaypoint = $Waypoints[ 0 ];
                $IdWaypoint = $Waypoints[ 1 ];
                $EpWaypoint = $Waypoints[ 2 ];
                $EdWaypoint = $Waypoints[ 3 ];
                $TermWaypoint = $Waypoints[ 4 ];
                
                die unless( $IpWaypoint->getOrder() =~ m/${\INNER_PICKUP_SUFF}/ );
                die unless( $IdWaypoint->getOrder() =~ m/${\INNER_DELIVERY_SUFF}/ );
                die unless( $EpWaypoint->getOrder() =~ m/${\EXTRA_PICKUP_SUFF}/ );
                die unless( $EdWaypoint->getOrder() =~ m/${\EXTRA_DELIVERY_SUFF}/ );
                die unless( $TermWaypoint->getOrder() =~ m/${\TERMINAL_SUFF}/ );
            }
            else
            {
                die;
            }
        }
        
        PrintVehicleData( $VehName, $IpWaypoint, $IdWaypoint, $EpWaypoint, $EdWaypoint, $TermWaypoint );
        print "\n";
            
    }
}



sub main
{
    # -sol-xml <file_path_name>
    clCommandLine::Init( [ '-sol-xml' ], [ '-no-term' ], ['-sol-xml'] );
    clCommandLine::Parse();
    
    my $GvrpSolution = clGvrpSolution::Parser::ParseSolution( clCommandLine::GetValue( '-sol-xml' ) );
    PresentSolution( $GvrpSolution );
}


main();






