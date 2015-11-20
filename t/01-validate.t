#!/usr/bin/perl

use strict;
use warnings;
use Test::More;

my $min_ver = 0.09;
eval "use Test::Map::Tube $min_ver tests => 2";
plan skip_all => "Test::Map::Tube $min_ver required" if $@;

use Map::Tube::Melbourne;
my $map = Map::Tube::Melbourne->new;
ok_map($map);
ok_map_functions($map);

