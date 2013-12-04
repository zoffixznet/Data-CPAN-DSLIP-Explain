package Data::CPAN::DSLIP::Explain;

use warnings;
use strict;

our $VERSION = '0.04';

use Carp;

sub new {
    my $class = shift;
    croak "Must have even number of arguments to ->new()"
        if @_ & 1;
    my %args = @_;
    $args{ lc $_ } = delete $args{ $_ } for keys %args;
    return bless \%args, $class;
}

sub dslip {
    my $self = shift;
    my $dslip = $self->_convert_dslip( @_ );
    if ( wantarray ) {
        return @$dslip;
    }
    else {
        return $dslip->[0];
    }
}

sub _convert_dslip {
    my $self = shift;
    my @dslips = @_;

    my $explanation_of = $self->_get_dslip_explanations;
    my @result;
    foreach my $dslip ( @dslips ) {
        my %codes;
        @codes{ qw(D S L I P) } = map { lc } split //, $dslip;

        $codes{ $_ } = $explanation_of->{ $_ }{ $codes{$_} }
            for keys %codes;

        push @result, \%codes;
    }

    return \@result;
}

sub explain_dslip_letter {
    my $self = shift;
    my $dslip_letter = uc shift;
    my $explanation_of = $self->_get_dslip_explanations;
    return $explanation_of->{ $dslip_letter }{info};
}

sub _get_dslip_explanations {
    my $self = shift;
    return {
        D => {
            info   => 'Development Stage (Note: *NO IMPLIED TIMESCALES*)',
            i      => 'Idea, listed to gain consensus or as a placeholder',
            c      => 'under construction but pre-alpha (not yet released)',
            a      => 'Alpha testing',
            b      => 'Beta testing',
            r      => 'Released',
            'm'    => 'Mature (no rigorous definition)',
            's'    => 'Standard, supplied with Perl',
        },

        S => {
            info    => 'Support Level',
            'm'     => 'Mailing-list',
            d       => 'Developer',
            u       => 'Usenet newsgroup comp.lang.perl.modules',
            n       => 'None known, try comp.lang.perl.modules',
        },

        L => {
            info    => 'Language Used',
            p       => 'Perl-only, no compiler needed, '
                        . 'should be platform independent',
            c       => 'C and perl, a C compiler will be needed',
            h       => 'written in perl with optional C code, '
                            . 'no compiler needed',
            '+'     => 'C++ and perl, a C++ compiler will be needed',
            o       => 'perl and another language other than C or C++',
        },

        I => {
            info    => 'Interface Style',
            f       => 'plain Functions, no references used',
            h       => 'hybrid, object and function interfaces available',
            n       => 'no interface at all (huh?)',
            r       => 'some use of unblessed References or ties',
            o       => 'Object oriented using blessed references '
                        . 'and/or inheritance',
        },

        P => {
            info    => 'Public License',
            p       => 'Standard-Perl: user may choose between GPL '
                            . 'and Artistic',
            g       => 'GPL: GNU General Public License',
            l       => 'LGPL: "GNU Lesser General Public License"'
                        . '(previously known as "GNU Library '
                        . 'General Public License")',
            b       => 'BSD: The BSD License',
            a       => 'Artistic license alone',
            o       => 'other (but distribution allowed '
                            . 'without restrictions)',
        }
    }
}

1;
__END__


=head1 NAME

Data::CPAN::DSLIP::Explain - "decrypts" CPAN module DSLIP code

=head1 SYNOPSIS

    use strict;
    use warnings;

    use Data::CPAN::DSLIP::Explain;

    my $dslip = 'Sdcfp';

    my $obj = Data::CPAN::DSLIP::Explain->new;

    my $meaning = $obj->dslip( $dslip );

    print "\nDSLIP code `$dslip` means:\n",
            join "\n\t",
                map {
                    $obj->explain_dslip_letter( $_ )
                    . "\n\t\t$meaning->{$_}"
                } qw(D S L I P);

    print "\n\n----\n";

=head1 DESCRIPTION

The module explains the DSLIP codes for those
of us who have bad memory. DSLIP stands for B<D>evelopment Stage,
B<S>upport Level, B<L>anguage Used, B<I>nterface Style, B<P>ublic License.
DSLIP codes is what'd you'd see in CPAN module list.

=head1 METHODS

=head2 new

    my $object = Data::CPAN::DSLIP::Explain->new;

Creates and returns a new Data::CPAN::DSLIP::Explain object.
Takes no arguments.

=head2 dslip

    my $meaning = $object->dslip( 'Sdcfp' );
    my @meanings = $object->dslip( qw( Sdcfp Sdcfp Sdcfp ) );

    $VAR1 = {
        'D' => 'Standard, supplied with Perl',
        'S' => 'Developer',
        'L' => 'C and perl, a C compiler will be needed'
        'I' => 'plain Functions, no references used',
        'P' => 'Standard-Perl: user may choose between GPL and Artistic',
    };

Takes one or more arguments which should be DSLIP codes. In scalar context
returns the meaning of the first DSLIP in a form of a hashref. In
list context returns a list of explanations for one or several DSLIP
code passed as arguments. The meaning is a hashref with keys being
each of the letters of DSLIP:

=over 4

=item D

Will contain I<Development Stage> of the module.

=item S

Will contain I<Support Level> of the module.

=item L

Will contain module's I<Language Used>.

=item I

Will contain description of module's I<Interface Style>.

=item P

Will contain module's I<Public License> type.

=back

=head2 explain_dslip_letter

    my $D_means = $object->explain_dslip_letter('D');
    my $S_means = $object->explain_dslip_letter('S');
    my $L_means = $object->explain_dslip_letter('L');
    my $I_means = $object->explain_dslip_letter('I');
    my $P_means = $object->explain_dslip_letter('P');

Takes one argument which is a letter of DSLIP acronym and returns an
explaination of what that letter stands for. In other words
$object->explain_dslip_letter('S'); would return C<Support Level>.

=head1 AUTHOR

Zoffix Znet, C<< <zoffix at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-data-cpan-dslip-explain at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-CPAN-DSLIP-Explain>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::CPAN::DSLIP::Explain

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Data-CPAN-DSLIP-Explain>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Data-CPAN-DSLIP-Explain>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Data-CPAN-DSLIP-Explain>

=item * Search CPAN

L<http://search.cpan.org/dist/Data-CPAN-DSLIP-Explain>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2008 Zoffix Znet, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut
