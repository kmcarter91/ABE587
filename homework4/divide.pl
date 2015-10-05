#!/usr/bin/env perl

use strict;
use warnings;

#file:divide.pl

my $length = @ARGV;
#open STDOUT, '>', 'out.txt';
#open STDERR, '>', 'err.txt';

if ($length < 2) {
    die("Please provide two numbers. \n");
}
elsif ($length > 2) {
    die("Please provide only two numbers. \n");
}

my $first  = shift @ARGV;
my $second = shift @ARGV;

if (($first < 0) || ($second < 0)) {
    die("Please provide two positive numbers. \n");
}
elsif ($second == 0) {
    die("Denominator must be nonzero");
}

print($first / $second, "\n");

__END__

Just print STDOUT/STDERR.  Also, you added rather than divided. 

One point off.
