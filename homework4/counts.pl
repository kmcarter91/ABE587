#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';

#file:counts.pl

my $file = 'Perl_III.fastq';
my $out  = 'counts.txt';
open my $fh, '<', $file;
#open STDOUT, '>', $out;

my $lines      = undef;
my $characters = undef;
my $total      = 0;
while (my $line = <$fh>) {
    $lines++;
    $characters = length $line;
    $total      = $total + $characters;
    chomp($line);
}

say "The total number of lines is: $lines";
say "The total number of characters is: $total";
say "The average nubmer of characters per line is: ", $total / $lines;

__END__

Never "open" STDOUT.  It's there.  Just "print."
