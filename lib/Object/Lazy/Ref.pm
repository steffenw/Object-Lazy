package Object::Lazy::Ref;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(croak);

my %register;

BEGIN {
    my $old_core_global_ref = *CORE::GLOBAL::ref;
    *CORE::GLOBAL::ref = sub ($) {
        my $ref = shift;

        return
            exists $register{$ref}
            ? $register{$ref}
            : do {
                local *CORE::GLOBAL::ref = $old_core_global_ref;
                ref $ref;
            };
    }
}

sub register {
    my $object = shift;

    $register{$object} = $object->{ref};

    return;
}

# $Id$

1;

__END__

=pod

=head1 NAME

Object::Lazy::Ref - Simulation of C<ref $object> for Object::Lazy

=head1 VERSION

0.01

=head1 SYNOPSIS

    use Object::Lazy::Ref;

    Object::Lazy::Ref::register($object);

=head1 DESCRIPTION

Simulation of C<ref $obj> for Object::Lazy

=head1 SUBROUTINES/METHODS

=head2 sub register

switch on the simulation.

    Object::Lazy::Ref::register($object);

=head1 DIAGNOSTICS

nothing

=head1 CONFIGURATION AND ENVIRONMENT

nothing

=head1 DEPENDENCIES

nothing

=head1 INCOMPATIBILITIES

This module will change *CORE::GLOBAL::ref premanently.
If a call of sub ref not matched with an registered Object::Lazy object
the *CORE::GLOBAL::ref will be restored during call
and will fall back after that.

When another programm decided to change *CORE::GLOBAL::ref permanently
it has to fallback to the old *CORE::GLOBAL::ref too.
This is than the Object::Lazy one.
When it bails out to CORE::ref, the pipe is broken.

=head1 BUGS AND LIMITATIONS

not known

=head1 AUTHOR

Steffen Winkler

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007 - 2009,
Steffen Winkler
C<< <steffenw at cpan.org> >>.
All rights reserved.

This module is free software;
you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut