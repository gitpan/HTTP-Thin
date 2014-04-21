package Pod::Elemental::Transformer;
# ABSTRACT: something that transforms a node tree into a new tree
$Pod::Elemental::Transformer::VERSION = '0.103000';
use Moose::Role;
use Moose::Autobox;

use namespace::autoclean;

requires 'transform_node';

# =head1 OVERVIEW
# 
# Pod::Elemental::Transformer is a role to be composed by anything that takes a
# node and messes around with its contents.  This includes transformers to
# implement Pod dialects, Pod tree nesting strategies, and Pod document
# rewriters.
# 
# A class including this role must implement the following methods:
# 
# =method transform_node
# 
#   my $node = $nester->transform_node($node);
# 
# This method alters the given node and returns it.  Apart from that, the sky is
# the limit.
# 
# =cut

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Pod::Elemental::Transformer - something that transforms a node tree into a new tree

=head1 VERSION

version 0.103000

=head1 OVERVIEW

Pod::Elemental::Transformer is a role to be composed by anything that takes a
node and messes around with its contents.  This includes transformers to
implement Pod dialects, Pod tree nesting strategies, and Pod document
rewriters.

A class including this role must implement the following methods:

=head1 METHODS

=head2 transform_node

  my $node = $nester->transform_node($node);

This method alters the given node and returns it.  Apart from that, the sky is
the limit.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
