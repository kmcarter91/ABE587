#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Getopt::Long;
use Pod::Usage;
use Bio::SeqIO;
use File::Path 'make_path';
use File::Spec::Functions 'catfile';
use File::Basename 'basename';
use Cwd 'cwd';

my %opts = get_opts();
my @args = @ARGV;

if ($opts{'help'} || $opts{'man'}) {
    pod2usage({
        -exitval => 0,
        -verbose => $opts{'man'} ? 2 : 1
    });
}

my $number;
my $out_dir; 
$out_dir = $opts{'out_dir'} or $out_dir=cwd;
make_path($out_dir);

my $seqname
my $count=0;
my $outseq;
while(scalar @args > 0){
    my $file = shift @args;
    say "1: ",basename($file);
    my $inseq = Bio::SeqIO->new( -file    => "<$file",
                                 -format  => 'fasta',
                               );
    while(my $seq = $inseq->next_seq){
        unless($count % $number){
            my $filepart=basename($file);
            my $outfile = catfile($out_dir,"$seqname");
            $outseq = Bio::SeqIO->new( -file   => ">$outfile",
                                       -format => 'fasta',
                                     ); 
            say("  -> ",$outfile);
        }
        $count++;
        $outseq->write_seq($seq);
    }
}

#say $count;
#say $number;
#say $out_dir;
#say "OK";



# --------------------------------------------------
sub get_opts {
    my %opts;
    GetOptions(
        \%opts,
        'number=n',
        'out_dir=s',
        'help',
        'man',
    ) or pod2usage(2);

    return %opts;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

01-fasta-splitter.pl - a script

=head1 SYNOPSIS

  01-fasta-splitter.pl -n 29 -o ~/split file1.fa [file2.fa ...]

Options:

  --number  The maximum number of sequences per file (500)
  --out_dir Output directory (cwd)
  --help    Show brief help and exit
  --man     Show full documentation

=head1 DESCRIPTION

Splits FASTA files into smaller files with a specified maximum number
of sequences (default set to 500) into a given output directory
(default the current working directory)

=head1 SEE ALSO

perl.

=head1 AUTHOR

Kyle Matthew Carter E<lt>kmcarter91@email.arizona.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 kmcarter91

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
