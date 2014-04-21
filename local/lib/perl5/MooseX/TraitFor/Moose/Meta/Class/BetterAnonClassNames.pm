#
# This file is part of MooseX-Util
#
# This software is Copyright (c) 2012 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::TraitFor::Moose::Meta::Class::BetterAnonClassNames;
BEGIN {
  $MooseX::TraitFor::Moose::Meta::Class::BetterAnonClassNames::AUTHORITY = 'cpan:RSRCHBOY';
}
$MooseX::TraitFor::Moose::Meta::Class::BetterAnonClassNames::VERSION = '0.002';
# ABSTRACT: Metaclass trait

use Moose::Role;
use namespace::autoclean;
use MooseX::AttributeShortcuts;
use autobox::Core;

# debugging...
#use Smart::Comments '###';

has is_anon => (is => 'ro', isa => 'Bool', default => 0);

has anon_package_prefix => (
    is       => 'ro',
    isa      => 'Str',
    builder  => 1,
    #init_arg => 'anon_package_prefix',
);

sub _build_anon_package_prefix { Moose::Meta::Class->_anon_package_prefix }

#sub _anon_package_prefix { shift->name . '::Package::__ANON__::SERIAL::' }
#has _anon_package_prefix => (
    #is      => 'rwp',
    #isa     => 'Str',
    #clearer => 1,
    #builder => sub { 'Reindeer' . shift->_anon_package_middle },
#);

#sub _anon_package_middle { '::Package::__ANON__::SERIAL::' }
sub _anon_package_middle { '::__ANON__::SERIAL::' }

# XXX around?
sub _anon_package_prefix {
    my $thing = shift @_;

    my $prefix = blessed $thing
        ? $thing->anon_package_prefix
        : Moose::Meta::Class->_anon_package_prefix
        ;

    my @caller = caller 1;
    ### @caller
    ### $prefix
    return $prefix;
}

around create => sub {
    my ($orig, $self) = (shift, shift);
    my @args = @_;

    unshift @args, 'package'
        if @args % 2;
    my %opts = @args;

    return $self->$orig(%opts)
        unless $opts{is_anon} && $opts{anon_package_prefix};

    ### old anon package name: $opts{package}
    my $serial = $opts{package}->split(qr/::/)->[-1]; #at(-1); #tail(1);
    $opts{package} = $opts{anon_package_prefix} . $serial;

    ### new anon package name: $opts{package}
    ### %opts
    return $self->$orig(%opts);
};

around create_anon_class => sub {
    my ($orig, $class) = (shift, shift);
    my %opts = @_;

    # we're going to need some additional logic here to make sure that our
    # prefixes make sense; e.g. if we're an anon descendent of an anon class,
    # we should just use our parent's prefix.

    $opts{is_anon} = 1;

    my $superclasses = $opts{superclasses} // [];

    # don't bother doing anything else if we don't have anything to add
    return $class->$orig(%opts)
        if exists $opts{anon_package_prefix};
    return $class->$orig(%opts)
        unless @$superclasses && @$superclasses == 1;

    # XXX ::class_of?
    my $sc = $superclasses->[0]->meta;

    #my $prefix
    $opts{anon_package_prefix}
        = $sc->is_anon
        ? $sc->_anon_package_prefix
        : $superclasses->[0] . $class->_anon_package_middle
        ;

    # basically:  if we have no superclasses, live with the default prefix; if
    # we have a superclass and it's anon, use it's anon prefix; if we have a
    # superclass and it's not anon, make a new prefix out of it
    #
    # cases where we have 2+ superclasses aren't handled right now; we use the
    # Moose::Meta::Class::_anon_package_prefix() for those
    #
    # if we're passed in 'anon_package_prefix', then just use that.

    return $class->$orig(%opts);
};

!!42;

__END__

=pod

=encoding UTF-8

=for :stopwords Chris Weyl

=head1 NAME

MooseX::TraitFor::Moose::Meta::Class::BetterAnonClassNames - Metaclass trait

=head1 VERSION

This document describes version 0.002 of MooseX::TraitFor::Moose::Meta::Class::BetterAnonClassNames - released March 03, 2014 as part of MooseX-Util.

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<MooseX::Util|MooseX::Util>

=back

=head1 SOURCE

The development version is on github at L<http://github.com/RsrchBoy/moosex-util>
and may be cloned from L<git://github.com/RsrchBoy/moosex-util.git>

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/RsrchBoy/moosex-util/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Chris Weyl <cweyl@alumni.drew.edu>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Chris Weyl.

This is free software, licensed under:

  The GNU Lesser General Public License, Version 2.1, February 1999

=cut
