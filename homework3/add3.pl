#!/usr/bin/env perl
use strict;
use warnings;
#file:add.pl 
my $length = @ARGV;

if($length < 2){
die("Please provide two numbers. \n");
}
elsif($length > 2){
die("Please provide only two numbers. \n");
}

my $first = shift @ARGV;
my $second = shift  @ARGV;

if(($first < 0) || ($second < 0)){
die("Please provide two positive numbers. \n")
}

print $first + $second, "\n";
