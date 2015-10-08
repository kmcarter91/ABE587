#!/usr/bin/env perl
use warnings;
use strict;
use autodie;

if(scalar(@ARGV)<2){
    die("Please provide two sequences.\n");
}
elsif(scalar(@ARGV)>2){
    die("Please provide only two sequences.\n");
}
my $first  = shift @ARGV;
my $second = shift @ARGV;
if(length $first != length $second){
    die("Please ensure the sequences are the same length.\n");
}
my @one = split('',$first);
my @two = split('',$second);
my $cnt = 0;
for my $pos (0..((length $first) -1)){
    my $on = shift @one;
    my $tw = shift @two;
    if($on ne $tw){
        print "Pos ", $pos+1,": ", $on," => ",$tw,"\n";
        $cnt++;
    }
}
print "Found $cnt SNP";
print "s" if $cnt!=1;
print "\n";
