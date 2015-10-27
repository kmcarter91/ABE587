#! usr/bin/env perl
use strict;
use warnings;
use autodie;
use feature 'say';

my $incore  = "core.txt";
my $invar   = "variable.txt";
my $inkegg  = "kegg_to_path";
my $out     = "path_percent.txt";

open my $core_fh ,"<", $incore;
open my $var_fh  ,"<", $invar;
open my $kegg_fh ,"<", $inkegg;
open my $out_fh  ,">", $out;

my @tmp;
my %cores;
my %variables;
my %corepath;
my %varpath;
my %pathway;

for my $line (<$core_fh>){
    chomp $line;
    $cores{$line}=1;
}

for my $line (<$var_fh>){
    chomp $line;
    $variables{$line}=1;
}

for my $line (<$kegg_fh>){
    chomp $line;
    @tmp = split(/\t/,$line);
    if(defined($cores{$tmp[0]})){
        $corepath{$tmp[1]}++;
        $pathway{$tmp[1]}++;
    }
    elsif(defined($variables{$tmp[0]})){
        $varpath{$tmp[1]}++;
        $pathway{$tmp[1]}++;
    }
}

for my $path (keys %pathway){
    if(defined($corepath{$path}) && defined($varpath{$path})){
        say $out_fh ("$path:\n",($corepath{$path}/$pathway{$path}),"% Core,  ",($varpath{$path}/$pathway{$path}),"% Variable");
    }
    elsif(defined($corepath{$path})){
        say $out_fh "$path:\n100% Core,  0% Variable" ;
    }
    elsif(defined($varpath{$path})){
        say $out_fh "$path:\n0% Core,  100% Variable";
    }
}
