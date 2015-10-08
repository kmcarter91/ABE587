#!/usr/bin/env perl
use warnings;
use strict;
use autodie;

if(scalar(@ARGV)<1){
    die("Please provide a list of sequences.\n");
}
my @args = @ARGV;
my @srt = sort {$a <=> $b} @args;
my @rst = sort {$b <=> $a} @args;

print "sorted = ",join(', ',@srt),"\n";
print "reverse = ",join(', ',@rst),"\n";


