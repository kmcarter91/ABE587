#!/usr/bin/env perl
use warnings;
use strict;
use autodie;

if(scalar(@ARGV)<1){
    die("Please provide a list of numbers.\n");
}
my @args = @ARGV;
my $even=0;
my $odd=0;
for my $element (@args){
  if ($element % 2 ==0){
    $even = $even + $element;
  }
  else{
    $odd = $odd + $element;
  }
}
print "sum evens = $even\n";
print "sum odds = $odd\n";


