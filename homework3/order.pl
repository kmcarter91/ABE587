#!/usr/bin/env perl
use strict;
use warnings;
#file:add.pl 
my $length = @ARGV;

if($length < 2){
die("Please provide two strings. \n");
}
elsif($length > 2){
die("Please provide only two strings. \n");
}

my @ordered = sort @ARGV;
if($ordered[0] eq $ARGV[0]){
print "right order \n";
}
else{
print "wrong order \n";
}
