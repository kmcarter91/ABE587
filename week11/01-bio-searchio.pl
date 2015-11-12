#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Getopt::Long;
use Pod::Usage;
use Bio::SearchIO;

my %opts = get_opts();
my @args = @ARGV;

if ($opts{'help'} || $opts{'man'}) {
    pod2usage({
        -exitval => 0,
        -verbose => $opts{'man'} ? 2 : 1
    });
}

my $infile=shift @args;
my $indata=new Bio::SearchIO(-format => 'blast',
                             -file   => $infile,
                            );
say("query\thit\tevalue");


while( my $current = $indata->next_result){
    while( my $hit = $current->next_hit){
        while( my $hsp = $hit->next_hsp){
            if($hsp->evalue <= 1e-50){
                print($hsp->query_string,"\t");
                print($hsp->hit_string,"\t");
                say($hsp->evalue);
            }
        }
    }
}

#say "OK";

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

01-bio-searchio.pl

=head1 SYNOPSIS

  01-bio-searchio.pl query_v_sprot.blastout

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Parses Blast output using "Bio::SearchIO" and retrieves HSP for hits with significance less than or equal to 1x10^-50.


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
