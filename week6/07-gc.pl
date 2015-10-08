#!/usr/bin/env perl
use warnings;
use strict;
use autodie;

if(scalar(@ARGV)<1){
    die("Please provide a sequence.\n");
}
my @args = @ARGV;
for my $element (@args){
  print "-------\n";
  my $lng = length($element);
  my $cnt = $element =~ tr/GgCc/GgCc/;
  print "Seq: $element \n";
  print "Length: $lng \n";
  print "#GC: $cnt \n";
  print "%GC: ";
  printf "%.2f",$cnt*100/$lng;
  print "%\n";
}



