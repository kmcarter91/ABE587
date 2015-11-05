#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Getopt::Long;
use Pod::Usage;
use Bio::SeqIO;

my %opts = get_opts();
my @args = @ARGV;

if ($opts{'help'} || $opts{'man'}) {
    pod2usage({
        -exitval => 0,
        -verbose => $opts{'man'} ? 2 : 1
    });
}

while(scalar @args > 0){
    my $infile = shift @args;
    my $inseq = Bio::SeqIO->new( -file   => ">$infile",
                              -format => 'genbank',
                            );

}

say "OK";

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

03-find-cds.pl - a script

=head1 SYNOPSIS

  03-find-cds.pl rec.gb [rec2.gb ...]

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Prints out coding regions given a GenBank record.

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
