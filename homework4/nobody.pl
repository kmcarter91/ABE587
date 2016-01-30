#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

#file:nobody.pl

my $file = 'Perl_III.nobody';
open my $fh, '<', $file;

#my $nbdy = undef;
#my $sbdy = undef;

while (my $line = <$fh>) {
    my $nbdy = index $line, 'Nobody';
    my $sbdy = index $line, 'somebody';

    if ($nbdy != -1) {
        print("Nobody was found at index: ", $nbdy, "\n");
    }
    if ($sbdy != -1) {
        warn("Somebody was found at index: ", $sbdy, "! \n");
    }
    chomp($line);
}

__END__

ll. 12-13: Always declare variables in the smallest possible scope.

ll. 19, 22: Better to use >=

l. 25: The chomp is useless.
