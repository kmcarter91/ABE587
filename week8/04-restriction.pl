#! usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use autodie;

if(scalar @ARGV < 1){
    die("Please provide a sequence or file.\n");
}
my $in = shift @ARGV;
open my $infh,"<",$in;
my @sequence;
while (my $line = <$infh>){
    chomp $line;
    push(@sequence,$line);
}
my $seq = join('',@sequence);
#say $seq;
$seq =~ s/([AG])AATT([CT])/$1^AATT$2/g;
say $seq;
