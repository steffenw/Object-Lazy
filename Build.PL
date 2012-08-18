use strict;
use warnings;

use Module::Build;

Module::Build->new(
    module_name       => 'Object::Lazy',
    license           => 'perl',
    dist_abstract     => 'Object::Lazy - create objects late from non-owned classes',
    dist_author       => 'Steffen Winkler <steffenw at cpan.org>',
    dist_version_from => 'lib/Object/Lazy.pm',
    requires          => {
        perl      => '5.006',
        Carp      => 0, # perl dist
        Try::Tiny => 0, #perl dist
    },
    build_requires => {
        'Test::NoWarnings'  => 0,
        'Test::Exception'   => 0,
        'Test::Differences' => '0.60',
        Cwd                 => 0, # perl dist
        'Test::More'        => 0, # dist Test-Simple
        'Params::Validate'  => 0,
    },
    recommends => {
        'Test::Pod'           => '1.14',
        'Test::Pod::Coverage' => '1.04',
    },
    create_makefile_pl   => 'traditional',
    recursive_test_files => 0,
    add_to_cleanup       => [ qw(
        META.yml *.bak *.gz Makefile.PL
    ) ],
)->create_build_script;
