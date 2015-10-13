#!/usr/bin/env perl

use warnings;
use strict;
use autodie;

#if ( scalar(@ARGV) < 1 ) {
unless (@ARGV) {
    die("Please provide a list of numbers.\n");
}
my @even;
for my $element (@ARGV) {
    if ( $element % 2 == 0 ) {
        push( @even, $element );
    }
}
print join( ', ', @even ), "\n";


__END__

No reason to copy @ARGV if you're just going over it.

Not the exact expected output.
