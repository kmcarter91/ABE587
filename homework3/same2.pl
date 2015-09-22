#!/usr/bin/env perl
use strict;
use warnings;
#file:add.pl 
print "Enter string 1: ";
my $first = <STDIN>;
print "Enter string 2: ";
my $second = <STDIN>;

my $ff = lc $first;
my $ss = lc $second;
if($ff eq $ss){
print "same \n";
}
else{
print "different \n";
}
