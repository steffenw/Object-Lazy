#!perl

use strict;
use warnings;

our $VERSION = 0;

use Object::Lazy;

my $object = Object::Lazy->new(
    sub {
        # A lazy Data::Dumper object as example
        # will show you use or require late too.
        require Data::Dumper;
        return Data::Dumper->new(['data'], ['my_dump']);
    },
);

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
        "\$condition = $condition;\n",
        qq{'$object' = "\$object";\n};

    return;
}

# do nothing
do_something_with($object, 0);

# build the real object and call method Dump
do_something_with($object, 1);

# $Id$