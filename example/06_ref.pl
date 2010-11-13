#!perl

use strict;
use warnings;

our $VERSION = 0;

use Object::Lazy;
use Object::Lazy::Ref; # overwrite CORE::GLOBAL::ref

my $object = Object::Lazy->new({
    build => sub {
        return RealClass->new();
    },
    # set the ref answer
    ref   => 'RealClass',
    # tell me when
    logger => sub {
        my $at_stack = shift;
        () = print "RealClass $at_stack";
    },
});

my $ref = ref $object;
() = print "$ref = ref \$object;\n";

my $coderef = $object->can('new');
# There is no simulation available for method can.
# The object has to build.
() = print "$coderef = \$object->can('new')\n";

# $Id$


package RealClass;

sub new {
    return bless {}, shift;
}

__END__

output:

RealClass = ref $object;
RealClass object built at ../lib/Object/Lazy.pm line 32
    eval {...} called at ../lib/Object/Lazy.pm line 31
    Object::Lazy::__ANON__('Object::Lazy=HASH(...)', 'REF(...)') called at ../lib/Object/Lazy.pm line 102
    Object::Lazy::can('Object::Lazy=HASH(...)', 'new') called at 06_ref.pl line 27
CODE(...) = $object->can('new')