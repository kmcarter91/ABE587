#!/usr/bin/env perl
use strict;
use warnings;
use autodie;
#file:nobody.pl
 
my $file = 'Perl_III.nobody';
open my $fh,'<',$file;
my $nbdy = undef;
my $sbdy = undef;
while (my $line = <$fh>){
  $nbdy = index $line,'Nobody';
  $sbdy = index $line,'somebody';
  if($nbdy != -1){
    print("Nobody was found at index: ", $nbdy, "\n");
  }
  if($sbdy != -1){
    warn("Somebody was found at index: ", $sbdy, "! \n");
  }
  chomp($line);
}

