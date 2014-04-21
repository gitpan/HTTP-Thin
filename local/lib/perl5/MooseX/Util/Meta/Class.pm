#
# This file is part of MooseX-Util
#
# This software is Copyright (c) 2012 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::Util::Meta::Class;
BEGIN {
  $MooseX::Util::Meta::Class::AUTHORITY = 'cpan:RSRCHBOY';
}
$MooseX::Util::Meta::Class::VERSION = '0.002';
# ABSTRACT: A helper metaclass

use Moose;
use namespace::autoclean;
use MooseX::AttributeShortcuts;

extends 'Moose::Meta::Class';
with 'MooseX::TraitFor::Moose::Meta::Class::BetterAnonClassNames';

# NOTE: making this package immutable breaks our metaclass compatibility!
#__PACKAGE__->meta->make_immutable;
!!42;

__END__

=pod

=encoding UTF-8

=for :stopwords Chris Weyl

=head1 NAME

MooseX::Util::Meta::Class - A helper metaclass

=head1 VERSION

This document describes version 0.002 of MooseX::Util::Meta::Class - released March 03, 2014 as part of MooseX-Util.

=head1 SYNOPSIS

    # create a new type of Zombie catcher equipped with machete and car
    my $meta = MooseX::Util::Meta::Class->create_anon_class(
        'Zombie::Catcher' => qw{
            Zombie::Catcher::Tools::Machete
            Zombie::Catcher::Tools::TracyChapmansFastCar
         },
     );

    # created anon classname is: Zombie::Catcher::__ANON__::SERIAL::42

=head1 DESCRIPTION

This is a trivial extension of L<Moose::Meta::Class> that consumes the
L<BetterAnonClassNames|MooseX::TraitFor::Moose::Meta::Class::BetterAnonClassNames>
trait.

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
