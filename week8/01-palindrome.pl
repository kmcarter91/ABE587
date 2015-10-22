#! usr/bin/env perl
use strict;
use warnings;
use feature 'say';

if(scalar @ARGV < 1){
    die("Please provide a word or phrase.\n");
}
my $phrase = shift @ARGV;
$phrase =~ s/[\s]|[^A-Za-z]//g;

if(lc $phrase eq reverse lc $phrase){
    say "Yes";
}
else{
    say "No";
}
