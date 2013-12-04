#!/usr/bin/perl -w

use strict;
use warnings;
use lib qw(../lib  lib);
use Data::CPAN::DSLIP::Explain;

die "Usage: perl explain_dslip.pl DSLIP\n"
    unless @ARGV == 1;

my $dslip = shift;

my $obj = Data::CPAN::DSLIP::Explain->new;

my $meaning = $obj->dslip( $dslip );

print "\nDSLIP code `$dslip` means:\n\t",
        join "\n\t",
            map {
                $obj->explain_dslip_letter( $_ )
                . "\n\t\t$meaning->{$_}"
            } qw(D S L I P);

print "\n\n----\n";

