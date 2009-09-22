package Object::Lazy;

use strict;
use warnings;

our $VERSION = '0.06';

use Carp qw(confess);
use English qw(-no_match_vars $EVAL_ERROR);
use Object::Lazy::Validate 0.01;

sub new { ## no critic (ArgUnpacking)
    my ($class, $params) = Object::Lazy::Validate::validate_new(@_);

    $params = Object::Lazy::Validate::init($params);
    my $self = bless $params, $class;
    if (exists $params->{ref}) {
        Object::Lazy::Ref::register($self);
    }

    return $self;
}

my $build_object = sub {
    my $self = shift;

    my $built_object = $self->{build}->();
    # don't build a second time
    $self->{build} = sub {return $built_object};
    if (! $self->{is_built} && exists $self->{logger}) {
        () = eval {
            confess('object built');
        };
        $self->{logger}->($EVAL_ERROR);
    }
    $self->{is_built} = 1;

    return $built_object;
};

sub DESTROY {} # is not AUTOLOAD

sub AUTOLOAD { ## no critic (Autoloading ArgUnpacking)
    my ($self, @params) =  @_;

    $_[0] = my $built_object
          = $build_object->($self);
    my $method = substr our $AUTOLOAD, 2 + length __PACKAGE__;

    return $built_object->$method(@params);
}

sub isa {
    my ($self, $class2check) = @_;

    my @isa = (ref $self->{isa} eq 'ARRAY')
              ? @{ $self->{isa} }
              : ($self->{isa});
    if ($self->{is_built} || ! @isa) {
        my $built_object = $build_object->($self);
        return $built_object->SUPER::isa($class2check);
    }
    CLASS: for my $class (@isa) {
        $class->isa($class2check) and return 1;
    }
    my %isa = map { ($_ => undef) } @isa;

    return exists $isa{$class2check};
}

sub can {
    my ($self, $method) = @_;

    my $built_object = $build_object->($self);

    return $built_object->SUPER::can($method);
}

# $Id$

1;

__END__

=pod

=head1 NAME

Object::Lazy - create objects late from non-owned classes

=head1 VERSION

0.06

=head1 SYNOPSIS

    use Foo 123; # because the class of the real object is Foo, version could be 123
    use Object::Lazy;

    my $foo = Object::Lazy->new(
        sub{
            return Foo->new();
        },
    );

    bar($foo);

    sub bar {
        my $foo = shift;

        if ($condition) {
            # a foo object will be created
            print $foo->output();
        }
        else {
            # foo object is not created
        }

        return;
    }

To combine this and a lazy use, write somthing like that:

    use Object::Lazy;

    my $foo = Object::Lazy->new(
        sub{
            my $code = 'use Foo 123';
            eval $code;
            $@ and die "$code $@";
            return Foo->new();
        },
    );

    # and so on

Read topic SUBROUTINES/METHODS to find the entended constructor
and all the optional parameters.

=head1 EXAMPLE

Inside of this Distribution is a directory named example.
Run this *.pl files.

=head1 DESCRIPTION

This module implements 'lazy evaluation'
and can create lazy objects from every class.

Creates a dummy object including a subroutine
which knows how to build the real object.

Later, if a method of the object is called,
the real object will be built.

Method isa and method can is implemented.

=head1 SUBROUTINES/METHODS

=head2 method new

=head3 short constructor

    $object = Object::Lazy->new(sub{
        return RealClass->new(...);
    });

=head3 extended constructor

    $object = Object::Lazy->new({
        build => sub {
            return RealClass->new(...);
        },
    });

=over 4

=item * optional parameter isa

There are 3 ways to check the class or inheritance.

If there is no parameter isa, the object must be built before.

If the C<use RealClass;> is outside of C<build => sub {...}>
then the class method C<RealClass->isa(...);> checks the class or inheritance.

Otherwise the isa parameter is a full notation of the class
and possible of the inheritance.

    $object = Object::Lazy->new({
        ...
        isa => 'RealClass',
    });

or

    $object = Object::Lazy->new({
        ...
        isa => [qw(RealClass BaseClassOfRealClass)],
    });

=item * optional parameter logger

Optional notation of the logger code to show the build process.

    $object = Object::Lazy->new({
        ...
        logger => sub {
            my $at_stack = shift;
            print "RealClass at_stack";
        },
    });

=item * optional parameter ref

Optional notation of the ref answer.

It is not a good idea to use the Object::Lazy::Ref module by default.
But there are situations, the lazy idea would run down the river
if I had not implemented this feature.

    use Object::Lazy::Ref; # overwrite CORE::GLOBAL::ref

    $object = Object::Lazy->new({
        ...
        ref => 'RealClass',
    });

    $boolean_true = ref $object eq 'RealClass';

=back

=head2 method isa

If no isa parameter was given at method new, the object will build.

Otherwise the method isa checks by isa class method
or only the given parameters.

    $boolean = $obejct->isa('RealClass');

or

    $boolean = $obejct->isa('BaseClassOfRealClass');

=head2 method can

The object will build. After that the can method checks the built object.

    $coderef_or_undef = $object->can('method');

=head1 DIAGNOSTICS

The constructor can confess at false parameters.

=head1 CONFIGURATION AND ENVIRONMENT

nothing

=head1 DEPENDENCIES

Carp

English

L<Object::Lazy::Validate>

=head1 INCOMPATIBILITIES

not known

=head1 BUGS AND LIMITATIONS

not known

=head1 SEE ALSO

L<Data::Lazy> The scalar will be built at C<my $scalar = shift;> at first sub call.

L<Scalar::Defer> The scalar will be built at C<my $scalar = shift;> at first sub call.

L<Class::LazyObject> No, I don't write my own class/package.

L<Object::Realize::Later> No, I don't write my own class/package.

L<Class::Cache> There are lazy parameters too.

L<Object::Trampoline> This is nearly the same idea.

L<Objects::Collection::Object> Object created at call of method isa.

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