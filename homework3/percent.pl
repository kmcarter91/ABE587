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
my $i = $ARGV[0];
my $j = $ARGV[1];
my $check = $i + $j;

if($check == 0){
  die("You are trying to trick me",'!');
}

my $prc = 100*$i/($i+$j);

print $prc,'%',"\n";
