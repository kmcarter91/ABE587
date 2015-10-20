#! usr/bin/env perl
use strict;
use warnings;
use autodie;
use Data::Dumper;
use feature 'say';

my $in;
if (scalar @ARGV < 1){
    $in="Perl_V.genesAndSeq.txt";
}
else{
    $in=shift @ARGV;
}
open my $in_fh, "<", $in;
my %Seqs;
my $length;
my $ident;
while (my $line = <$in_fh>){
    chomp $line;
    #print substr($line,0,1)," ";
    #print substr($line,1,-1)," ";
    if(substr($line,0,1)eq '>'){
        $ident=substr($line,1);
        $length = 0; 
    }
    else{
        $length += length($line);
        #say $ident," ",$length;
        $Seqs{$ident} = $length;
    }
}


for my $seq (sort {$Seqs{$a} <=> $Seqs{$b}} keys %Seqs){
    my $count = $Seqs{$seq};
    say "$seq: $count";
}
