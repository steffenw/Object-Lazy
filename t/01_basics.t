#!perl -T

use 5.006001;
use strict;
use warnings;

use Test::More tests => 13 + 1;
use Test::NoWarnings;
use Test::Exception;

BEGIN { use_ok('Object::Lazy') }

# build at isa
my $object = Object::Lazy->new(\&TestSample::create_object);
isa_ok $object, 'TestSample', 'after isa method:';

# build at method
$object = Object::Lazy->new(\&TestSample::create_object);
my_sub($object);
sub my_sub {
    my $object = shift;
    is ref $object, 'Object::Lazy', 'ref object is Object::Lazy';
    is $object->method(), 'method output', 'check method output';
}

# build at can
$object = Object::Lazy->new(\&TestSample::create_object);
ok $object->can('method'), 'can method';
isa_ok $object, 'TestSample', 'after build:';

# isa from given isa
$object = Object::Lazy->new({
    build => \&TestSample::create_object,
    isa   => 'MyClass',
});
isa_ok $object, 'MyClass', 'parameter isa is MyClass:';

$object = Object::Lazy->new({
    build => \&TestSample::create_object,
    isa   => [qw(NotExists TestSample)],
});
isa_ok $object, 'NotExists', 'parameter isa is qw(NotExists TestSample):';
# ask class about isa
@TestSample::ISA = qw(TestBase);
isa_ok $object, 'TestBase', 'base class of TestSample:';

# logger
$object = Object::Lazy->new({
    build => \&TestSample::create_object,
    logger => sub {like shift(), qr{\A object \s built \s at \s}xms, 'test log message'},
});
$object->method();

# ref
throws_ok(
    sub {
        $object = Object::Lazy->new({
            build => \&TestSample::create_object,
            ref   => 'MyClass',
        });
    },
    qr{depends \s use \s Object::Lazy::Ref}xms,
    'error at paramater ref',
);
$object = Object::Lazy->new({
    build => \&TestSample::create_object,
});
is ref $object, 'Object::Lazy', 'ref is Object::Lazy';

# write back scalar
$object = Object::Lazy->new(\&TestSample::create_object);
$object->method();
is $object->{test_key}, 'test_value', 'directly object data access';

#-----------------------------------------------------------------------------

package TestSample;

sub new {
    return bless {test_key => 'test_value'}, shift;
}

sub method {
    return 'method output';
}

# it's a sub, not a method
sub create_object {
    return TestSample->new();
}

#-----------------------------------------------------------------------------

package TestBase;