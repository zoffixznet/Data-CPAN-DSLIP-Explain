# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Data-CPAN-DSLIP-Explain.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 26;
BEGIN {
    use_ok('Carp');
    use_ok('Data::CPAN::DSLIP::Explain');
};


use strict;
use warnings;

use Data::CPAN::DSLIP::Explain;

my $o = Data::CPAN::DSLIP::Explain->new;

isa_ok($o, 'Data::CPAN::DSLIP::Explain');

my $meaning = $o->dslip( 'Sdcfp' );

is(
    ref $meaning,
    'HASH',
    "scalar context ->dslip()",
);

my @meanings = $o->dslip( qw( Sdcfp bdpOp ) );

for ( @meanings ) {
    is(
        ref $_,
        'HASH',
        "list context ->dslip()",
    );
}

for ( $meanings[0], $meaning ) {
    
    is( $_->{D}, 'Standard, supplied with Perl', "{D} key in `Sdcfp`" );
    is( $_->{S}, 'Developer', "{S} key in `Sdcfp`" );
    is( $_->{L}, 'C and perl, a C compiler will be needed',
        "{L} key in `Sdcfp`");
    is( $_->{I}, 'plain Functions, no references used',
        "{I} key in `Sdcfp`");
    is( $_->{P}, 'Standard-Perl: user may choose between GPL and Artistic',
        "{P} key in `Sdcfp`");
}

is(
    $meanings[1]->{D},
    'Beta testing',
    '{D} key in bdpOp',
);

is(
    $meanings[1]->{S},
    'Developer',
    '{S} key in bdpOp',
);

is(
    $meanings[1]->{L},
    'Perl-only, no compiler needed, should be platform independent',
    '{L} key in bdpOp',
);

is(
    $meanings[1]->{I},
    'Object oriented using blessed references and/or inheritance',
    '{I} key in bdpOp',
);

is(
    $meanings[1]->{P},
    'Standard-Perl: user may choose between GPL and Artistic',
    '{P} key in bdpOp',
);


is(
    $o->explain_dslip_letter('D'),
    'Development Stage (Note: *NO IMPLIED TIMESCALES*)',
);

is(
    $o->explain_dslip_letter('S'),
    'Support Level',
    q|$o->explain_dslip_letter('S')|,
);

is(
    $o->explain_dslip_letter('L'),
    'Language Used',
    q|$o->explain_dslip_letter('L')|,
);

is(
    $o->explain_dslip_letter('I'),
    'Interface Style',
    q|$o->explain_dslip_letter('I')|,
);

is(
    $o->explain_dslip_letter('P'),
    'Public License',
    q|$o->explain_dslip_letter('P')|,
);
