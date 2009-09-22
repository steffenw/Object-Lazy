#!perl

use strict;
use warnings;

our $VERSION = 0;

use Object::Lazy;

my $object = Object::Lazy->new({
    # how to create the real object
    build  => sub {
        return RealClass->new();
    },
    # do not build at method isa
    # isa => 'RealClass',
    # or
    isa    => [qw(RealClass BaseClassOfRealClass)],
    # tell me when
    logger => sub {
        my $at_stack = shift;
        () = print "RealClass $at_stack";
    },
});

{
    my $ok = $object->isa('RealClass');
    () = print "$ok = \$object->isa('RealClass');\n";
}

# ask about inheritage
{
    my $ok = $object->isa('BaseClassOfRealClass');
    () = print "$ok = \$object->isa('BaseClassOfRealClass');\n";
}

# build the real object and call method output
$object->output();

# $Id$

package RealClass;

use parent qw(-norequire BaseClassOfRealClass);


package BaseClassOfRealClass; ## no critic (MultiplePackages)

sub new {
    return bless {}, shift;
}

sub output {
    () = print "# Method output called!\n";

    return;
}