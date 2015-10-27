#! usr/bin/env perl
use strict;
use warnings;
use autodie;
use feature 'say';

my $infirst  = "SRR029686.uproc";
my $insecond = "SRR029687.uproc";
my $inthird  = "SRR029688.uproc";
my $infourth = "SRR029692.uproc";
my $outlean  = "lean_only.txt";
my $outobese = "obese_only.txt";

open my $infs_fh ,"<", $infirst;
open my $insc_fh ,"<", $insecond;
open my $inth_fh ,"<", $inthird;
open my $inft_fh ,"<", $infourth;

open my $lean  ,">", $outlean;
open my $obese ,">", $outobese;

my @tmp;
my %first;
my %second;
my %third;
my %fourth;
my %all;

for my $line (<$infs_fh>){
    chomp $line;
    @tmp = split(',',$line);
    $first{$tmp[0]}=$tmp[1];
    $all{$tmp[0]}++;
}

for my $line (<$insc_fh>){
    chomp $line;
    @tmp = split(',',$line);
    $second{$tmp[0]}=$tmp[1];
    $all{$tmp[0]}++;
}

for my $line (<$inth_fh>){
    chomp $line;
    @tmp = split(',',$line);
    $third{$tmp[0]}=$tmp[1];
    $all{$tmp[0]}++;
}

for my $line (<$inft_fh>){
    chomp $line;
    @tmp = split(',',$line);
    $fourth{$tmp[0]}=$tmp[1];
    $all{$tmp[0]}++;
}

for my $ids (keys %all){
    if(!defined($first{$ids}) && defined($second{$ids}) && 
       !defined($third{$ids}) && defined($fourth{$ids})){
        #say "here";
        if($second{$ids} + $fourth{$ids}>50){
            say $lean $ids;
            #say "there";
        }
    }
    elsif(defined($first{$ids}) && !defined($second{$ids}) &&
          defined($third{$ids}) && !defined($fourth{$ids})){
        if($first{$ids} + $third{$ids}>50){
            say $obese $ids;
        }
    }
}
