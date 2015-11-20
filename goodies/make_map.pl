#!/usr/bin/perl

use strict;
use warnings;

use WWW::PTV;

my $p = WWW::PTV->new();

get_metro_lines();

sub get_metro_lines {
	my %routes = $p->get_metropolitan_train_routes();

	my @sorted_routes = 
        map  { $_->[0]                  }
        sort { $a->[1] cmp $b->[1]      }   
        map  { [ $_, $routes{ $_ } ]    } keys %routes;

	my $line = 1;

	for my $route ( @sorted_routes ) {
		my $route_id = ( split /\//, $route )[-1];
		# Flemington only has seasonal/event schedules, so skip it.
                next if $route_id == 1482;

		my $route = $p->get_route_by_id( $route_id );

		my @stops = $route->get_stop_names_and_id();

		$LINE{ $route_id }{ line } = $line_count;
		$LINE{ $route_id }{ name } = $routes{ $route };

		$line++;

		my @stops = $route->get_stop_names_and_ids();

		for my $stop ( @stops ) {
			$STOP{ $stop->[0] }{ name } = $stop->[1];
			$STOP{ $stop->[0] }{ line }{ $route_id }{ 
	}
}
