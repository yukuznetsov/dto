#!/usr/bin/perl
use lib '/home/ykuznetsov/Converters/';

use warnings;
use strict;
use clGvrpTask;
use clCommandLine;
use Data::Dumper;

use Scalar::Util qw(blessed);

use XML::LibXML; 

use constant INNER_PICKUP_SUFF => 'ip-';
use constant INNER_DELIVERY_SUFF => 'id-';
use constant EXTRA_PICKUP_SUFF => 'ep-';
use constant EXTRA_DELIVERY_SUFF => 'ed-';



sub ParseSolutionAndReturnMatching
{
    my $SolutionName = shift( @_ );
    die unless( defined($SolutionName) );

    my $parser = XML::LibXML->new(); 
    my $dom = $parser->parse_file( $SolutionName ) or die; # XML::LibXML::Document
    die unless ( $dom->isa('XML::LibXML::Document') );

    my $Solution = $dom->documentElement(); # XML::LibXML::Element
    die unless ( $Solution->isa('XML::LibXML::Element') );

    my @Routes = $Solution->getChildrenByTagName( "*" );

    my $Result = {}; # { VehId => [S_Id, F_Id], ... }
    foreach my $route ( @Routes )
    {
        die unless( $route->isa('XML::LibXML::Element') );
        
        my $VehId = $route->getAttribute( 'vehicle' );
        my $Dist = $route->getAttribute( 'dist' );
        die unless( defined($VehId) && defined($Dist) );
        
        my @TerminalElements = $route->getChildrenByTagName( 'terminal' );
        unless( scalar(@TerminalElements) == 1 && $TerminalElements[0]->isa('XML::LibXML::Element') )
        {
            print "unexpected XML format:\n";
            print $route->toString() . "\n";
            die;
        }
        
        my $TerminalElement = $TerminalElements[0];
        my @Waypoints = $route->getChildrenByTagName( 'waypoint' );
        
        my ( $IpElement, $IdElement, $EpElement, $EdElement );
        
        if( clCommandLine::GetValue( '-no-term' ) )
        {
            die if( grep { $_->getAttribute( 'order' ) =~ m/Terminal_/ } @Waypoints );
            die unless( scalar(@Waypoints) == 4 || scalar(@Waypoints) == 2 );
            
            if( scalar(@Waypoints) == 4 )
            {
                ( $IpElement, $IdElement, $EpElement, $EdElement ) = @Waypoints;
            }
            else
            {
                die unless( scalar(@Waypoints) == 2 );
                ( $IpElement, $IdElement, $EpElement, $EdElement ) = ( @Waypoints, undef, undef );
            }
        }
        else
        {
            die unless( scalar(@Waypoints) == 5 || scalar(@Waypoints) == 3 );
            
            my $TerminalElement;
            if( scalar(@Waypoints) == 5 )
            {
                ( $IpElement, $IdElement, $EpElement, $EdElement, $TerminalElement ) = @Waypoints;
            }
            else
            {
                die unless( scalar(@Waypoints) == 3 );
                ( $IpElement, $IdElement, $TerminalElement, $EpElement, $EdElement ) = ( @Waypoints, undef, undef );
            }
            
            die unless( $TerminalElement->getAttribute( 'order' ) =~ m/Terminal_/ );
            die if( grep { defined($_) && $_->getAttribute( 'order' ) =~ m/Terminal_/ } ($IpElement, $IdElement, $EpElement, $EdElement)  );
        }
                
        die unless( $IpElement->isa('XML::LibXML::Element') &&
                    $IdElement->isa('XML::LibXML::Element') &&
                    (!defined($EpElement) || $EpElement->isa('XML::LibXML::Element')) &&        
                    (!defined($EdElement) || $EdElement->isa('XML::LibXML::Element'))    );
                    
        if( defined($EpElement) && defined($EdElement) )
        {
            my $IpId = $IpElement->getAttribute( 'order' );
            my $IdId = $IdElement->getAttribute( 'order' );
            my $EpId = $EpElement->getAttribute( 'order' );
            my $EdId = $EdElement->getAttribute( 'order' );
            
            die "$IpId <- '${\INNER_PICKUP_SUFF}'" unless( $IpId =~ m/${\INNER_PICKUP_SUFF}/ );
            die "$IdId <- '${\INNER_DELIVERY_SUFF}'" unless( $IdId =~ m/${\INNER_DELIVERY_SUFF}/ );
            die "$EpId <- '${\EXTRA_PICKUP_SUFF}'" unless( $EpId =~ m/${\EXTRA_PICKUP_SUFF}/ );
            die "$EdId <- '${\EXTRA_DELIVERY_SUFF}'" unless( $EdId =~ m/${\EXTRA_DELIVERY_SUFF}/ );
            
            
            $VehId =~ s/(^\s+|\s+$)//g;
            $EpId =~ s/(^\s+|\s+$)//g;
            $EdId =~ s/(^\s+|\s+$)//g;
            
            
            die if( exists(  $Result->{$VehId} ) );
            $Result->{$VehId} = [ $EpId, $EdId ];
        }
    }
    
    return $Result;    
}



sub main
{
    # -task <file_path_name> -sol-xml <file_path_name>
    clCommandLine::Init( [ '-task', '-sol-xml' ], [ '-no-term' ], [ '-task', '-sol-xml' ] );
    clCommandLine::Parse();


    my $GvrpTask = clGvrpTask::FromFile( clCommandLine::GetValue( '-task' ) );
    my $Assignment = ParseSolutionAndReturnMatching( clCommandLine::GetValue( '-sol-xml' ) );

    my %SetOfAssignedOperations;
    foreach my $veh ( keys %$Assignment )
    {
        die unless( scalar(@{$Assignment->{$veh}}) == 2 );
        my $pop = $Assignment->{$veh}->[ 0 ];
        my $dop = $Assignment->{$veh}->[ 1 ];
        
        die "duplicated PickUp Id = '$pop'" if( exists($SetOfAssignedOperations{$pop}) );
        die "duplicated Delivery Id = '$dop'" if( exists($SetOfAssignedOperations{$dop}) );
        
        $SetOfAssignedOperations{$pop} = 1;
        $SetOfAssignedOperations{$dop} = 1;
    }


    my $CargoSection = $GvrpTask->getCargoes();
    my $NodeSection = $GvrpTask->getNodes();
    my $FleetSection = $GvrpTask->getFleet();

    my $Cargoes = $CargoSection->getCargoes();
    my $Nodes = $NodeSection->getNodes();
    my $Fleet = $FleetSection->getVehicles();


    if( grep {  !exists( $SetOfAssignedOperations{ $_->getPickupName() } ) && exists( $SetOfAssignedOperations{ $_->getDeliveryName() } ) ||
                exists( $SetOfAssignedOperations{ $_->getPickupName() } ) && !exists( $SetOfAssignedOperations{ $_->getDeliveryName() } )    } @$Cargoes )
    {
        die 'unconsistency';
    }

    my @FilteredCargoes = grep { !exists( $SetOfAssignedOperations{ $_->getPickupName() } ) && !exists( $SetOfAssignedOperations{ $_->getDeliveryName() } ) } @$Cargoes;
    my @FilteredNodes = grep { !exists( $SetOfAssignedOperations{ $_->getName() } ) } @$Nodes;
    my @FilteredFleet = @$Fleet;

    # check
    {
        my $CountOfAssignedOps = scalar( keys %SetOfAssignedOperations );
    
        my @DroppedCargoes = grep { exists( $SetOfAssignedOperations{ $_->getPickupName() } ) && exists( $SetOfAssignedOperations{ $_->getDeliveryName() } ) } @$Cargoes;
        my @DroppedNodes = grep { exists( $SetOfAssignedOperations{ $_->getName() } ) } @$Nodes;
    
        die unless( $CountOfAssignedOps % 2 == 0 );
        die unless( scalar(@DroppedCargoes) == ($CountOfAssignedOps / 2) );
        die unless( scalar(@DroppedNodes) == $CountOfAssignedOps );
    }


    my $FilteredCargoSection = clGvrpTask::CargoSection::FromArray( \@FilteredCargoes );
    my $FilteredNodeSection = clGvrpTask::NodeSection::FromArray( \@FilteredNodes );
    my $FilteredVehicleSection = clGvrpTask::VehicleSection::FromArray( \@FilteredFleet );

    my $FilteredTask = clGvrpTask::New( $FilteredCargoSection, $FilteredNodeSection, $FilteredVehicleSection );

    $FilteredTask->printAsCsv();
}




main();

