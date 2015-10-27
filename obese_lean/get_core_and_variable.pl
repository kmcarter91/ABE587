#! usr/bin/env perl
use strict;
use warnings;
use autodie;
use feature 'say';

my $infirst  = "SRR029686.uproc";
my $insecond = "SRR029687.uproc";
my $inthird  = "SRR029688.uproc";
my $infourth = "SRR029692.uproc";

open my $infs_fh ,"<", $infirst;
open my $insc_fh ,"<", $insecond;
open my $inth_fh ,"<", $inthird;
open my $inft_fh ,"<", $infourth;

my @tmp;
my %first;
my %second;
my %third;
my %fourth;

for my $line (<$infs_fh>){
    chomp $line;
    @tmp = split(',',$line);
    $first{$tmp[0]}=$tmp[1];
}

for my $line (<$insc_fh>){
    chomp $line;
    @tmp = split(',',$line);
    $second{$tmp[0]}=$tmp[1];
}

for my $line (<$inth_fh>){
    chomp $line;
    @tmp = split(',',$line);
    $third{$tmp[0]}=$tmp[1];
}

for my $line (<$inft_fh>){
    chomp $line;
    @tmp = split(',',$line);
    $fourth{$tmp[0]}=$tmp[1];
}

my %shared;
my @all = (keys %first, keys %second, keys %third, keys %fourth);
my %unique;
$unique{$_}++ foreach @all;
my %cores;
my %variables;
#say keys %unique;

for my $element (keys %unique){
    if(defined($first{$element}) && defined($second{$element})
    && defined($third{$element}) && defined($fourth{$element})){
        if($first{$element}>50 && $second{$element}>50
        && $third{$element}>50 && $fourth{$element}>50){
            $cores{$element}=1;
        }
        else{
            $cores{$element}=1;
        }
    }
    else{
        $variables{$element}=1;
    }
}
#say keys %cores;
#say join("\n",keys %cores);

open my $core,     ">", "core.txt";
open my $variable, ">", "variable.txt";

print $core     join("\n",keys %cores);
print $variable join ("\n",keys %variables);
