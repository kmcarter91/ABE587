#!/usr/bin/env perl
use warnings;
use strict;
use autodie;

if(scalar(@ARGV)<1){
    die("Please provide a list of sequences.\n");
}
my @args = @ARGV;
my @srt = sort {$a <=> $b} @args;
my @rst = sort {$b <=> $a} @args;

print "sorted = ",join(', ',@srt),"\n";
print "reverse = ",join(', ',@rst),"\n";

__END__

You're using <=> which is numerical sort when you ought to be using
"cmp".  It produces many errors:

[catalina@~/work/students/kmcarter91/week6]$ perl 05-string-sort.pl ATGCCCGGCCCGGC GCGTGCTAGCAATACGATAAACCGG ATATATATCGAT ATGGGCCC
Argument "ATGCCCGGCCCGGC" isn't numeric in sort at 05-string-sort.pl line 10.
Argument "GCGTGCTAGCAATACGATAAACCGG" isn't numeric in sort at 05-string-sort.pl line 10.
Argument "ATATATATCGAT" isn't numeric in sort at 05-string-sort.pl line 10.
Argument "ATGGGCCC" isn't numeric in sort at 05-string-sort.pl line 10.
sorted = ATGCCCGGCCCGGC, GCGTGCTAGCAATACGATAAACCGG, ATATATATCGAT, ATGGGCCC
reverse = ATGCCCGGCCCGGC, GCGTGCTAGCAATACGATAAACCGG, ATATATATCGAT, ATGGGCCC

This makes Perl convert the strings to numbers so they becomes zeros and 
don't end up sorting at all!

Two points off.
