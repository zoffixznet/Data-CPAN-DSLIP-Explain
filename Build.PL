use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Data::CPAN::DSLIP::Explain',
    license             => 'perl',
    dist_author         => 'Zoffix Znet <zoffix@cpan.org>',
    dist_version_from   => 'lib/Data/CPAN/DSLIP/Explain.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        Carp => 0,
        'perl' => '5.006',
    },
    configure_requires => { 'Module::Build' => 0 },
    add_to_cleanup      => [ 'Data-CPAN-DSLIP-Explain-*' ],
    create_makefile_pl => 'traditional',
);

if ( $ENV{RELEASE_TESTING} ) {
    system('pod2text lib/Data/CPAN/DSLIP/Explain.pm > README');
}

$builder->create_build_script();
