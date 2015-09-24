#!/usr/bin/env perl
use strict;
use warnings;
use autodie;
#file:counts.pl
 
my $file = 'Perl_III.fastq';
my $out='counts.txt';
open my $fh,'<',$file;
open STDOUT,'>',$out;

my $lines=undef;
my $characters=undef;
my $total=0;
while (my $line = <$fh>){
  $lines++;
  $characters = length $line;
  $total = $total + $characters;
  chomp($line);
}
print("The total number of lines is: $lines \n");
print("The total number of characters is: $total \n");
print("The average nubmer of characters per line is: ", $total/$lines, "\n");
