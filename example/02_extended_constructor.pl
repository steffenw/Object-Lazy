#!perl ## no critic (TidyCode)

use strict;
use warnings;

our $VERSION = 0;

use Object::Lazy;

my $object = Object::Lazy->new({
    # A lazy Data::Dumper object as example
    # will show you use or require late too.
    build  => sub {
        require Data::Dumper;
        return Data::Dumper->new(['data'], ['my_dump']);
    },
    # tell me when
    logger => sub {
        my $at_stack = shift;
        () = print "Data::Dumper $at_stack";
    },
});

sub do_something_with {
    my ($object, $condition) = @_; ## no critic (ReusedNames)

    if ($condition) {
        # the Data::Dumper object will be created
        () = print $object->Dump();
    }
    else {
        # the Data::Dumper object is not created
    }
    () = print
        "condition = $condition\n",
        "object = $object\n";

    return;
}

# do nothing
do_something_with($object, 0);

# build the real object and call method Dump
do_something_with($object, 1);

# $Id$

__END__

output:

1 = $object->isa('RealClass');
1 = $object->isa('BaseClassOfRealClass');
Data::Dumper object built at ../lib/Object/Lazy.pm line 32
    eval {...} called at ../lib/Object/Lazy.pm line 31
    Object::Lazy::__ANON__('Object::Lazy=HASH(...)', 'REF(...)') called at ../lib/Object/Lazy.pm line 47
    Object::Lazy::AUTOLOAD('Object::Lazy=HASH(...)') called at 02_extended_constructor.pl line 38
# Method output called!
