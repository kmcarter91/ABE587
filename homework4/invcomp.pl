#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

#file:invcomp.pl

my $file = 'Perl_III.fasta';
my $out  = 'invcomp.txt';
open my $fh, '<', $file;
#open STDOUT, '>', $out;

while (my $line = <$fh>) {
    my $nol  = substr($line, 0, -1);
    my @char = split("", $nol);

    if ($char[0] eq '>') {
        print $nol, " | Reverse Complement Chain \n";
    }
    else {
        my $revcomp = reverse $nol;
        $revcomp =~ tr/ACGTNacgtn/TGCANtgcan/;
        print $revcomp, "\n";
    }
    chomp($line);
}

__END__

Much more efficient to look at first char with

  if (substr($line, 0, 1) eq '>') {

Line 26: "chomp($line)" doesn't do anything useful.
