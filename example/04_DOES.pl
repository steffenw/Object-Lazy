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
    # do not build at method DOES
    # inheritance
    isa    => 'RealClass', # array reference allowed too
    # roles
    DOES   => 'Role',      # array reference allowed too
    # tell me when
    logger => sub {
        my $at_stack = shift;
        () = print "RealClass $at_stack";
    },
});

{
    my $ok = $object->DOES('RealClass');
    () = print "$ok = \$object->DOES('RealClass');\n";
}
{
    my $ok = $object->DOES('RealClass');
    () = print "$ok = \$object->DOES('Role');\n";
}

# build the real object and call method output
$object->output();

# $Id$

package RealClass;

sub new {
    return bless {}, shift;
}

sub output {
    () = print "# Method output called!\n";

    return;
}

__END__

output:

1 = $object->DOES('RealClass');
1 = $object->DOES('Role');
RealClass object built at ../lib/Object/Lazy.pm line 32
    eval {...} called at ../lib/Object/Lazy.pm line 31
    Object::Lazy::__ANON__('Object::Lazy=HASH(...)', 'REF(...)') called at ../lib/Object/Lazy.pm line 47
    Object::Lazy::AUTOLOAD('Object::Lazy=HASH(...)') called at 04_DOES.pl line 37
# Method output called!
