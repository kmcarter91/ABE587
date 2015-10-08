#!/usr/bin/env perl
use warnings;
use strict;
use autodie;

if(scalar(@ARGV)<1){
    die("Please provide a list of numbers.\n");
}
my @args = @ARGV;
my @def = sort @args;
my @nst = sort {$a <=> $b} @args;
my @rns = sort {$b <=> $a} @args;

print "default sort = ",join(', ',@def),"\n";
print "default sort = ",join(', ',@nst),"\n";
print "reverse numerical sort = ",join(', ',@rns),"\n";


