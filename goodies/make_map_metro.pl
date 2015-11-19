#!perl

BEGIN { unshift @INC, '.' }

use strict;
use warnings;

use WWW::PTV;
use Data::Dumper;

my $p = WWW::PTV->new();

#process_routes();
#
#sub process_routes {
#	my $p = shift;
#
#	my $routes = $p->get_metropolitan_train_routes();
#
#	for my $route ( sort keys %routes ) {
#		
#	}
#}

my @alpha	= ( "A" .. "Z" );
my $count	= 0;
my $out;
my %LINE;
my %STOP;
my %routes = $p->get_metropolitan_train_routes();
my @sorted_routes = 
	map  { $_->[0]			}
	sort { $a->[1] cmp $b->[1]	}
	map  { [ $_, $routes{ $_ } ]	} keys %routes;

header();

for my $route_url ( @sorted_routes ) {
	my $route_id = ( split /\//, $route_url )[-1];
	next if $route_id == 1482;

	my $route = $p->get_route_by_id( $route_id );

	my @stops = $route->get_stop_names_and_ids();

	$LINE{ $alpha[ $count ] }{ name } = $routes{ $route_url };
	line( $alpha[ $count ], $routes{ $route_url }, "#ccc" );

	$STOP{ sprintf( "%s%02d", $alpha[ $count ], 1 ) }{ name }	= $stops[0]->[1];
	$STOP{ sprintf( "%s%02d", $alpha[ $count ], 1 ) }{ id }		= $stops[0]->[0];
	$STOP{ sprintf( "%s%02d", $alpha[ $count ], 1 ) }{ line }	= sprintf( "%s:%d", $alpha[ $count ] , 1 );
	push @{ $STOP{ sprintf( "%s%02d", $alpha[ $count ], 1 ) }{ link } }, sprintf( "%s%02d", $alpha[ $count ], 2 );

	for ( my $i = 1; $i < $#stops ; $i++ ) {
		$STOP{ sprintf( "%s%02d", $alpha[ $count ], $i + 1 ) }{ name }	= $stops[$i]->[1];
		$STOP{ sprintf( "%s%02d", $alpha[ $count ], $i + 1 ) }{ id }	= $stops[$i]->[0];
		$STOP{ sprintf( "%s%02d", $alpha[ $count ], $i + 1 ) }{ line }	= sprintf( "%s:%d",  $alpha[ $count ], $i + 1 );
		push @{ $STOP{ sprintf( "%s%02d", $alpha[ $count ], $i + 1 ) }{ link } }, sprintf( "%s%02d", $alpha[ $count ], $i );
		push @{ $STOP{ sprintf( "%s%02d", $alpha[ $count ], $i + 1 ) }{ link } }, sprintf( "%s%02d", $alpha[ $count ], $i+2 );
	}

	$STOP{ sprintf( "%s%02d", $alpha[ $count ], ~~@stops ) }{ name }= $stops[0]->[1];
	$STOP{ sprintf( "%s%02d", $alpha[ $count ], ~~@stops ) }{ id }	= $stops[0]->[0];
	$STOP{ sprintf( "%s%02d", $alpha[ $count ], ~~@stops ) }{ line }= sprintf( "%s:%d", $alpha[ $count ] , ~~@stops );
	push @{ $STOP{ sprintf( "%s%02d", $alpha[ $count ], ~~@stops ) }{ link } }, sprintf( "%s%02d", $alpha[ $count ], ~~@stops - 1 );

	$count++;

}


#my @s =	map { $_->[0]				}
#	sort{ $a->[1] cmp $b->[1]		}
#	map { [ $_, $STOP{ $_ }{ id } ]	} keys %STOP;

for my $s ( sort keys %STOP ) {
	my $link = join ",", @{ $STOP{ $s }{ link } };
	print <<"XML";
			<station id="$s" name="$STOP{ $s }{ name }" line="$STOP{ $s }{ line }" link="$link" />
XML
}

sub header {
	print <<"XML";
<?xml version="1.0" encoding="UTF-8"?>
	<tube name="Melbourne Metro">
		<lines>
XML
}

sub line {
	my ( $line_id, $line_name, $line_color ) = @_;
	
	$line_name = $line_id	unless $line_name;
	$line_color = "#333333"	unless $line_color;

	print <<"XML";
			<line id="$line_id" name="$line_name" color="$line_color" />
XML
}

sub station {
	my ( $station_id, $station_name, $station_line ) = @_;


}

sub end_line_section {
	print <<"XML";
		</lines>

		<stations>
XML
}
