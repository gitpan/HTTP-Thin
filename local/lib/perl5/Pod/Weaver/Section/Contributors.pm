package Pod::Weaver::Section::Contributors;
{
  $Pod::Weaver::Section::Contributors::VERSION = '0.007';
}
use Moose;
with 'Pod::Weaver::Role::Section';
# ABSTRACT: a section listing contributors

use Moose::Autobox;
use List::MoreUtils 'uniq';

use Pod::Elemental::Element::Nested;
use Pod::Elemental::Element::Pod5::Verbatim;



has head => (
    is      => 'rw',
    isa     => 'Int',
    lazy    => 1,
    default => 1,
);


sub mvp_multivalue_args { qw( contributors ) }


has contributors => (
    is      => 'rw',
    isa     => 'ArrayRef[Str]',
    lazy    => 1,
    default => sub{ [] },
);


has all_modules => (
    is      => 'rw',
    isa     => 'Bool',
    lazy    => 1,
    default => 0,
);


sub weave_section {
    my ($self, $document, $input) = @_;

    #
    # all_modules
    #
    #   this code is stealed from Pod::Weaver::Section::Support
    #

    ## Check if all_modules is found on the stash
    if ( $input->{zilla} ) {
        my $stash  = $input->{zilla}->stash_named('%PodWeaver');
        my $config = $stash->get_stashed_config($self) if $stash;

        $self->all_modules($config->{all_modules})
            if defined $config && defined $config->{all_modules};
    }

    ## Is this the main module POD?
    if ( ! $self->all_modules ) {
        return if $input->{zilla}->main_module->name ne $input->{filename};
    }

    #
    # contributors
    #

    ## 1 - add contributors passed to Dist::Zilla::Stash::PodWeaver
    if ( $input->{zilla} ) {
        my $stash = $input->{zilla}->stash_named('%PodWeaver');
        $stash->merge_stashed_config($self) if $stash;
    }

    ## 2 - get contributors passed to Pod::Weaver::Section::Contributors
    my @contributors = @{$self->contributors};

    ## 3 - get contributors from $input parameter of weave_section()
    push(@contributors, @{$input->{contributors}})
        if $input->{contributors} && ref($input->{contributors}) eq 'ARRAY';

    ## 4 - get contributors from source comments
    my $ppi_document = $input->{ppi_document};
    $ppi_document->find( sub {
        my $ppi_node = $_[1];
        if ($ppi_node->isa('PPI::Token::Comment') &&
            $ppi_node->content =~ qr/^\s*#+\s*CONTRIBUTORS?:\s*(.+)$/m ) {
            push (@contributors, $1);
        }
        return 0;
    });

    ## 5 - remove repeated names, and sort them alphabetically
    @contributors = uniq (@contributors);
    @contributors = sort (@contributors);

    return unless @contributors;

    ## 6 - add contributors to the stash as stopwords
    if ( $input->{zilla}
        and my $stash = $input->{zilla}->stash_named('%PodWeaver')
    ) {
        # TODO: no good way yet of registering a stash from a weaver section
        #do { $stash = PodWeaver->new; $self->_register_stash('%PodWeaver', $stash) }
        #    unless defined $stash;
        my $config = $stash->_config;

        my @stopwords = uniq
            map { $_ ? split / / : ()    }
            map { /^(.*?)(\s+<.*)?$/; $1 }
            @contributors;
        my $i = 0;
        # TODO: use the proper API (not yet written) to add this data
        do { $config->{"-StopWords.include[$i]"} = $_; $i++ }
            for @stopwords;
    }

    my $multiple_contributors = @contributors > 1;
    my $name = $multiple_contributors ? 'CONTRIBUTORS' : 'CONTRIBUTOR';

    my $result = [map {
        Pod::Elemental::Element::Pod5::Ordinary->new({
            content => $_,
        }),
    } @contributors];

    $result = [
        Pod::Elemental::Element::Pod5::Command->new({
            command => 'over', content => '4',
        }),
        $result->map(sub {
            Pod::Elemental::Element::Pod5::Command->new({
                command => 'item', content => '*',
            }),
            $_,
        })->flatten,
        Pod::Elemental::Element::Pod5::Command->new({
            command => 'back', content => '',
        }),
    ] if $multiple_contributors;

    #
    # head
    #

    ## Check if head is found on the stash
    if ( $input->{zilla} ) {
        my $stash  = $input->{zilla}->stash_named('%PodWeaver');
        my $config = $stash->get_stashed_config($self) if $stash;

        $self->head($config->{head}) if defined $config && defined $config->{head};
    }

    if ( $self->head ) {
        $document->children->push(
            Pod::Elemental::Element::Nested->new({
                type     => 'command',
                command  => 'head' . $self->head,
                content  => $name,
                children => $result,
            }),
        );
    }
    else {
        $document->children->push($_) for @$result;
    }
}

no Moose;
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Pod::Weaver::Section::Contributors - a section listing contributors

=head1 VERSION

version 0.007

=head1 SYNOPSIS

on dist.ini:

    [PodWeaver]
    [%PodWeaver]
    Contributors.head = 2
    Contributors.contributors[0] = keedi - Keedi Kim - 김도형 (cpan: KEEDI) <keedi@cpan.org>
    Contributors.contributors[1] = carandraug - Carnë Draug (cpan: CDRAUG) <cdraug@cpan.org>

and/or weaver.ini:

    [Contributors]
    head = 2
    contributors = keedi - Keedi Kim - 김도형 (cpan: KEEDI) <keedi@cpan.org>
    contributors = carandraug - Carnë Draug (cpan: CDRAUG) <cdraug@cpan.org>

and/or in the source of individual files:

    # CONTRIBUTOR:  keedi - Keedi Kim - 김도형 (cpan: KEEDI) <keedi@cpan.org>
    # CONTRIBUTORS: carandraug - Carnë Draug (cpan: CDRAUG) <cdraug@cpan.org>

=head1 DESCRIPTION

This section adds a listing of the documents contributors.  It expects a C<contributors>
input parameter to be an arrayref of strings.  If no C<contributors> parameter is
given, it will do nothing.  Otherwise, it produces a hunk like this:

    =head1 CONTRIBUTORS

    Contributor One <a1@example.com>
    Contributor Two <a2@example.com>

To support distributions with multiple modules, it is also able to derive a list
of contributors in a file basis by looking at comments on each module. Names of
contributors on the source, will only appear on the POD of those modules.

=head1 ATTRIBUTES

=head2 head

The heading level of this section.  If 0, it inserts an ordinary piece of text
with no heading. Defaults to 1.

In case the value is passed both to Pod::Weaver and to the Pod::Weaver stash,
it uses the value found in the stash.

=head2 contributors

The list of contributors.

In case the value is passed to C<weave_section()>, to Pod::Weaver
and to the Pod::Weaver stash, it merges all contributors.

=head2 all_modules

Enable this if you want to add the CONTRIBUTOR/CONTRIBUTORS section to
all the modules in a dist, not only the main one. Defaults to false.

In case the value is passed both to Pod::Weaver and to the Pod::Weaver stash,
it uses the value found in the stash.

=for Pod::Coverage mvp_multivalue_args

=for Pod::Coverage weave_section

=head1 SEE ALSO

=over 4

=item *

L<dagolden's 'How I'm using Dist::Zilla to give credit to contributors'|http://www.dagolden.com/index.php/1921/how-im-using-distzilla-to-give-credit-to-contributors/>

=item *

L<Dist::Zilla::Plugin::ContributorsFromGit>

=item *

L<Dist::Zilla::Stash::Contributors>

=item *

L<Dist::Zilla::Plugin::Meta::Contributors>

=item *

L<Dist::Zilla::Plugin::ContributorsFile>

=item *

L<Dist::Zilla>

=item *

L<Dist::Zilla::Role::Stash::Plugins>

=item *

L<Pod::Weaver>

=item *

L<Pod::Weaver::Section::Authors>

=back

=head1 AUTHOR

Keedi Kim - 김도형 <keedi@cpan.org>

=head1 CONTRIBUTORS

=over 4

=item *

carandraug - Carnë Draug (cpan: CDRAUG) <cdraug@cpan.org>

=item *

ether - Karen Etheridge (cpan: ETHER) <ether@cpan.org>

=item *

thaljef - Jeffrey Ryan Thalhammer (cpan: THALJEF) <thaljef@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Keedi Kim.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut