#!/usr/bin/env perl
use warnings;
use strict;
use autodie;

my @lst=(101,2,15,22,95,33,2,27,15,52);

print "array = ",join(', ',@lst),"\n";

my $popped = pop @lst;
print "popped = ",$popped,", array = ",join(', ',@lst),"\n"; 

my $shifted = shift @lst;
print "shifted = ",$shifted,", array = ",join(', ',@lst),"\n";

push(@lst,12);
print "after push, array = ",join(', ',@lst),"\n";

unshift(@lst,4);
print "after unshift, array = ",join(', ',@lst),"\n";


