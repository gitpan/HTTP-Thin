#
# This file is part of MooseX-Util
#
# This software is Copyright (c) 2012 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::Traitor;
BEGIN {
  $MooseX::Traitor::AUTHORITY = 'cpan:RSRCHBOY';
}
$MooseX::Traitor::VERSION = '0.002';
# ABSTRACT: An alternate way to compose your classes with traits

use Moose::Role;
use namespace::autoclean;
use MooseX::AttributeShortcuts;
use MooseX::Util ();


sub with_traits {
    my ($thing, @traits) = @_;

    my $class = blessed $thing || $thing;

    return MooseX::Util::with_traits($class => @traits);
}

!!42;

__END__

=pod

=encoding UTF-8

=for :stopwords Chris Weyl composable CLOS behaviour behaviours

=head1 NAME

MooseX::Traitor - An alternate way to compose your classes with traits

=head1 VERSION

This document describes version 0.002 of MooseX::Traitor - released March 03, 2014 as part of MooseX-Util.

=head1 SYNOPSIS

    # in your class definition...
    package MyClass;
    use Moose;
    use namespace::autoclean;

    with 'MooseX::Traitor';

    # somewhere else in Gotham...
    my $thinger = MyClass->with_traits('Thinger::Trait1')->new(...);

=head1 DESCRIPTION

One of the most powerful things about L<Moose> is that with roles and easy
"anonymous" class creation we are blessed with a fantastic new way of
creating classes, often on the fly, out of other classes and those composable
bits of behaviour, roles.

Even better, this application of discrete chunks of behaviours enables people
simply using a class to extend and tweak its behaviour in new ways -- possibly
ways never contemplated by the authors of the classes being altered.

=head1 METHODS

=head2 with_traits(<trait1>, ...)

This method builds an anonymous class from the consuming class and any traits
specified.

You may use the full trait specification syntax, e.g.:

    MyClass->with_traits('My::Trait' => { -excludes => ... })

Calling this routine with no traits specified will simply return the name of
the class.  This is not considered an error.

Note that we handle being called directly against a package (e.g.
C<MyClass->with_traits(...)>) and against an instance (e.g.
C<$self->with_traits(...)>) identically; in each instance the class
referenced is subclassed.

=head1 ROLES OR TRAITS?

There are many different definitions of what a role is vs a trait, ranging
from "hey man, it's all cool" to "CLOS calls them all traits SO TRAITS IS THE
ONE TRUE NAME", it seems that most people tend to think of them this way:

Roles are traits that a class knowingly consumes (e.g. via with()).

Traits are roles that are applied without the class' consent (e.g. anonymous
subclass composition or C<$trait_meta->apply('ClassThinger')>).

Or maybe that's just what this author is imposing on everyone else.  Either
way, that's what we'll be using here if the definition ever becomes important.

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
