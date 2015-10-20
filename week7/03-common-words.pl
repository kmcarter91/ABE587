#! usr/bin/env perl
use strict;
use warnings;
use autodie;
use feature 'say';

my $in_first= shift @ARGV;
my $in_second= shift @ARGV;

open my $in_first_fh, "<", $in_first;
open my $in_second_fh, "<", $in_second;
my $string = lc join("",<$in_first_fh>);
my $string2= lc join("",<$in_second_fh>);
$string=~s/[^A-Za-z0-9\s]//g;
$string2=~s/[^A-Za-z0-9\s]//g;
#say $string;

my @words = split(/\s+/,$string);
my @words2 = split(/\s+/,$string2);
#say @words;

my %words_hash = map{$_ => 1} @words;
my %words2_hash = map{$_ => 1} @words2;
my $count;

for my $word (sort keys %words2_hash){
    if(defined $words_hash{$word}){
        say $word;
        $count++;
    }
}
say "Found $count words in common."
