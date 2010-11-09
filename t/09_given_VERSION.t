#!perl -T

use 5.006;
use strict;
use warnings;

use Test::More tests => 3 + 1;
use Test::NoWarnings;

BEGIN { use_ok('Object::Lazy') }

my $object = Object::Lazy->new({
    build   => \&TestSample::create_object,
    VERSION => '123',
});
is(
    $object->VERSION(),
    '123'
    'VERSION',
);

is(
    ref $object,
    'Object::Lazy',
    'ref object is TestSample',
);

#-----------------------------------------------------------------------------

package TestSample;

sub new {
    return bless {}, shift;
}

# it's a sub, not a method
sub create_object {
    return TestSample->new();
}
