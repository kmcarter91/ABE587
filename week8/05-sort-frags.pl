#!usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use autodie;

my $tag = <STDIN>;
chomp $tag;
my @list= split(/\^/m,$tag);
my @srt= sort {length $a <=> length $b} @list;
say join ("\n", @srt);
