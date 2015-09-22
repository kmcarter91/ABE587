#!/usr/bin/env perl
use strict;
use warnings;
#file:add.pl 
print "Enter string 1: ";
my $first = <STDIN>;
print "Enter string 2: ";
my $second = <STDIN>;

if($first eq $second){
print "same \n";
}
else{
print "different \n";
}
