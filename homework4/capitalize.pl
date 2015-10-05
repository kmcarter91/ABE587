#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

#file:capitalize.pl

my $file = shift @ARGV or die 'No input';
open my $fh, '<', $file;
open STDOUT, '>', 'capfix.txt';

while (my $line = <$fh>) {
    print uc $line;
}

__END__

Don't chomp if you're printing a newline.
