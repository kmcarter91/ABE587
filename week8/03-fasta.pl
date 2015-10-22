#! usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use autodie;

if(scalar @ARGV < 1){
    die("Please provide a FASTA file.\n");
}
my $in = shift @ARGV;
open my $infh,"<",$in;

my $count;
while(my $line = <$infh>){
    chomp $line;
    if($line =~ />/){
        $count++;
        $line =~ s/>//;
        say "$count: $line";
    }
}
my $plural;
if($count == 1){
    $plural="";
}
else{
    $plural="s";
}
printf "Found $count sequence%s.\n",$plural;
