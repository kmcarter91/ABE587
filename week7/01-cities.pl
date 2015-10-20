#! usr/bin/env perl
use strict;
use warnings;
use autodie;
use Data::Dumper;
use feature 'say';

my %cities = (
    Lompoc      =>'CA',
    Huston      =>'TX',
    Albuquerque =>'NM',
    Buffalo     =>'NY',
    Orlando     =>'FL',
    Tucson      =>'AZ'
);

say Dumper(\%cities);
my $count;
for my $city (sort keys %cities){
    $count++;
    my $state = $cities{$city};
    say "$count: $city, $state";
}

