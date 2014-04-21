#
# This file is part of MooseX-Util
#
# This software is Copyright (c) 2012 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::Util;
BEGIN {
  $MooseX::Util::AUTHORITY = 'cpan:RSRCHBOY';
}
# git description: 0.001-9-gffe1241
$MooseX::Util::VERSION = '0.002';

# ABSTRACT: Moose::Util extensions

use strict;
use warnings;

use parent 'Moose::Util';

use MooseX::Util::Meta::Class;


# TODO allow with_traits() to be curried with different class metaclasses?

sub with_traits {
    my ($class, @roles) = @_;
    return $class unless @roles;
    return MooseX::Util::Meta::Class->create_anon_class(
        superclasses => [$class],
        roles        => \@roles,
        cache        => 1,
    )->name;
}


!!42;

__END__

=pod

=encoding UTF-8

=for :stopwords Chris Weyl

=head1 NAME

MooseX::Util - Moose::Util extensions

=head1 VERSION

This document describes version 0.002 of MooseX::Util - released March 03, 2014 as part of MooseX-Util.

=head1 SYNOPSIS

    use MooseX::Util qw{ ensure_all_roles with_traits };

    # profit!

=head1 DESCRIPTION

This is a utility module that handles all of the same functions that
L<Moose::Util> handles.  In fact, most of the functions exported by this
package are simply re-exports from L<Moose::Util>, so you're recommended to
read the documentation of that module for a comprehensive view.

However.

We've reimplemented a number of the functions our parent provides, for a
variety of reasons.  Those functions are documented here.

=head1 FUNCTIONS

=head2 with_traits(<classname> => (<trait1>, ... )

Given a class and one or more traits, we construct an anonymous class that is
a subclass of the given class and consumes the traits given.  This is exactly
the same as L<Moose::Util/with_traits>, except that we use
L<MooseX::Util::Meta::Class/create_anon_class> to construct the anonymous
class, rather than L<Moose::Meta::Class/create_anon_class> directly.

Essentially, this means that when we do:

    my $anon_class_name = with_traits('Zombie::Catcher', 'SomeTrait');

For $anon_class_name we get:

    Zombie::Catcher::__ANON__::SERIAL::1

Rather than:

    Moose::Meta::Class::__ANON__::SERIAL::1

This is nice because we have an idea of where the first anonymous class came
from, whereas the second one could could be from anywhere.

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Moose::Util>

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
