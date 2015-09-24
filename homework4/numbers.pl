#!/usr/bin/env perl
use strict;
use warnings;
use autodie;
#file: numbers.pl
#EC

# All even numbers below 24 (22 and 2) will be printed to STDOUT
# The factorial of all odd numbers and numbers bigger than 24 will be saved to myresult.txt

 
my $file = 'numbers.txt';
my $fact = 'myresult.txt';
open my $fh,'<',$file;
open my $fch, '>',$fact;

my $f=undef;
my $i=undef;

while (my $line = <$fh>){
  $f=1;
  $i=1;
  if ($line%2 == 0){
    if ($line < 24){
      print $line;
    }
  }
  else{
  $f*=++$i while $i < $line;
  print $fch ($f,"\n");
  }
  chomp($line);
}

