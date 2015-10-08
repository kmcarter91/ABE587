#!/usr/bin/env perl
use warnings;
use strict;
use autodie;

if(scalar(@ARGV)<1){
    die("Please provide a list of numbers.\n");
}
my @args = @ARGV;
my @even;
for my $element (@args){
  if ($element % 2 ==0){
    push(@even,$element);
  }
}
print join(', ',@even),"\n";


