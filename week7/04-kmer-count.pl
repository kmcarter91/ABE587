#! usr/bin/env perl
use strict;
use warnings;
use autodie;
use feature 'say';

my $lngth=3;
my $source;
if(scalar @ARGV < 1){
    die("Please provide a sequence.\n");
}
$source = shift @ARGV;
if(scalar @ARGV > 0){
    $lngth = shift @ARGV;
}
my @sequence;
my $seqcount;
if(-e $source){
    open my $in_fh,"<",$source;
    while (my $line = <$in_fh>){
        chomp $line;
        if(substr($line,0,1)eq'>'){
            $seqcount++;
            if($seqcount>1){
                die("More than one sequence.\n");
            }
        }
        else{
            push(@sequence,$line);
        }
    }
}
else{
    push(@sequence,$source);
}
unless(scalar @sequence){
    die("Zero-length sequence.\n");
}
my $seq = join('',@sequence);
my $sl=length $seq;
if($sl < $lngth){
    die("Cannot get any $lngth mers from a sequence of length $sl\n");
}

my %Kmers;
my $nb= $sl - $lngth + 1;
for(my $i=0;$i<$nb;$i++){
    my $km=substr($seq,$i,$lngth);
    if(!defined $Kmers{$km}){
        $Kmers{$km}=1;
    }
    else{
        $Kmers{$km}++;
    }
}
my $single;
for my $check (values %Kmers){
    if($check==1){
        $single++;
    }
}

printf("%-15s%11s\n","Sequence length",$sl);
printf("%-15s%11s\n","Mer size"       ,$lngth);
printf("%-15s%11s\n","Number of kmers",$nb);
printf("%-15s%11s\n","Unique kmers"   ,length values %Kmers);
printf("%-15s%11s\n","Num. Singletons",$single);
say "Most abundant";

my $kn;
for my $abundant (reverse sort {$Kmers{$a} <=> $Kmers{$b}} keys %Kmers){
    say "$abundant: ",$Kmers{$abundant};
    $kn++;
    if($kn == 10){
        exit;
    }
}
