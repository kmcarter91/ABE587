#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Getopt::Long;
use Pod::Usage;
use Bio::DB::Fasta;
use Bio::SeqIO;

my %opts = get_opts();
my @args = @ARGV;

if ($opts{'help'} || $opts{'man'}) {
    pod2usage({
        -exitval => 0,
        -verbose => $opts{'man'} ? 2 : 1
    });
}

my $infile  =shift @args or pod2usage("No file given.");
my $pattern =shift @args or pod2usage("No pattern given.");
my $outfile = $pattern;
$outfile =~ s/[^A-Z0-9]//;
$outfile =~ s/-//;
$outfile =~ s/]//;
$outfile = "$outfile.fa";

my $outseq = Bio::SeqIO->new( -file   => ">$outfile",
                           -format => 'fasta',
                         );


say qq(Searching '$infile' for '$pattern');

my $fastafh = Bio::DB::Fasta->new($infile) or pod2usage("File doesn't exist.");
my @ids = $fastafh->get_all_primary_ids;
my $count;
for my $id (@ids){
    if($id =~ /$pattern/){
        $count++;
        my $seq = $fastafh->get_Seq_by_id($id);
        $outseq->write_seq($seq);  
    }
}

say "Found $count ids";
say "See results in '$outfile'";

# --------------------------------------------------
sub get_opts {
    my %opts;
    GetOptions(
        \%opts,
        'help',
        'man',
    ) or pod2usage(2);

    return %opts;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

02-fasta-search.pl - a script

=head1 SYNOPSIS

  02-fasta-search.pl file.fa pattern 

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Returns a fasta file containing all sequences with the given pattern
in their sequence ID

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
