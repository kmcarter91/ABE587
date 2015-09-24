#!/usr/bin/env perl
use strict;
use warnings;
use autodie;
#file:capitalize.pl
 
my $file = shift @ARGV;
open my $fh,'<',$file;
open STDOUT,'>','capfix.txt';

while (my $line = <$fh>){
  chomp($line);
  print uc $line, "\n";
}


