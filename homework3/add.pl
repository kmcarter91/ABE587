#!/usr/bin/env perl
use strict;
use warnings;
#file:add.pl 

my $first = shift @ARGV;
my $second = shift  @ARGV;

print $first + $second, "\n";
