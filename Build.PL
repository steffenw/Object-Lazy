use strict;
use warnings;

use Module::Build;

my $is_ppm
    = (
        # install using ppm
        ! $ENV{AUTHOR_DIST}
        && eval 'require ActivePerl::PPM::Package'
    )
    || (
        # build ppm and ppd
        $ENV{AUTHOR_DIST}
        && $ENV{AUTHOR_DIST} eq 'ppm'
    );

Module::Build->new(
    module_name       => 'Object::Lazy',
    license           => 'perl',
    dist_abstract     => 'Object::Lazy - create objects late from non-owned classes',
    dist_author       => 'Steffen Winkler <steffenw at cpan.org>',
    dist_version_from => 'lib/Object/Lazy.pm',
    requires          => {
        perl               => 5.006,
        'Params::Validate' => 0,
        $is_ppm
        ? (
        )
        : (
            Carp    => 0, # perl dist
            English => 0, # perl dist
        )
    },
    build_requires => {
        'Test::NoWarnings' => 0,
        'Test::Exception'  => 0,
        $is_ppm
        ? (
            'Test::Simple' => 0,
        )
        : (
            Cwd          => 0, # perl dist
            'Test::More' => 0, # dist Test-Simple
        )
    },
    recommends => {
        # build
        'Test::Pod'           => '1.14',
        'Test::Pod::Coverage' => '1.04',
    },
    create_makefile_pl   => 'traditional',
    recursive_test_files => 1,
    add_to_cleanup       => [ qw(
        META.yml *.bak *.gz Makefile.PL
    ) ],
)->create_build_script();
