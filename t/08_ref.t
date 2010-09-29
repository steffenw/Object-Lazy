#!perl -T

use 5.006;
use strict;
use warnings;

use Test::More tests => 5 + 1;
use Test::NoWarnings;

BEGIN {
    use_ok('Object::Lazy');
    use_ok('Object::Lazy::Ref');
}

my $object = Object::Lazy->new({
    build => \&NotExists,
    ref   => 'MyClass',
});
is(
    ref $object,
    'MyClass',
    'ref is MyClass',
);
is(
    ref {},
    'HASH',
    'ref is HASH'
);
is(
    ref bless( {}, __PACKAGE__ ),
    __PACKAGE__,
    'ref is ' . __PACKAGE__,
);
