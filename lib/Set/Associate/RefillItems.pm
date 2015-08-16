use 5.006;
use strict;
use warnings;

package Set::Associate::RefillItems;
$Set::Associate::RefillItems::VERSION = '0.003001';
# ABSTRACT: Pool re-population methods
use Moose;
use MooseX::AttributeShortcuts;

use Set::Associate::Utils;
*_warn_nonmethod = *Set::Associate::Utils::_warn_nonmethod;































has name => (
  isa      => Str =>,
  is       => rwp =>,
  required => 1,
);













has code => (
  isa      => CodeRef =>,
  is       => rwp     =>,
  required => 1,
  traits   => ['Code'],
  handles  => {
    get_all => execute_method =>,
  },
);













has items => (
  isa       => ArrayRef  =>,
  is        => rwp       =>,
  predicate => has_items =>,
);

with 'Set::Associate::Role::RefillItems' => { can_get_all => 1, };

__PACKAGE__->meta->make_immutable;






















sub linear {
  if ( _warn_nonmethod( $_[0], __PACKAGE__, 'linear' ) ) {
    unshift @_, __PACKAGE__;
  }
  my ( $class, @args ) = @_;
  require Set::Associate::RefillItems::Linear;
  return Set::Associate::RefillItems::Linear->new(@args);
}























sub shuffle {
  if ( _warn_nonmethod( $_[0], __PACKAGE__, 'shuffle' ) ) {
    unshift @_, __PACKAGE__;
  }
  my ( $class, @args ) = @_;
  require Set::Associate::RefillItems::Shuffle;
  return Set::Associate::RefillItems::Shuffle->new(@args);
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Set::Associate::RefillItems - Pool re-population methods

=head1 VERSION

version 0.003001

=head1 DESCRIPTION

This class implements a generalized interface for creating objects which populate pools.

What you're mostly interested in are L</CLASS METHODS>, which are shorthand (somewhat) for loading and constructing
many of the C<Set::Associate::RefillItems::*> family.

However, if your code needs to design its own version on the fly, this interface should work:

    my $populator = Set::Associate::RefillItems->new(
        name => 'foo',
        items => [  .... ],
        code => sub {
            my ( $self, $sa ) = @_;
            ....
        },
    );
    my $sa = Set::Associate->new(
        on_item_empty => $populator ,
        ...
    );

=head1 CONSTRUCTOR ARGUMENTS

=head2 name

    required Str

=head2 code

    required CodeRef

=head2 items

    required ArrayRef

=head1 CLASS METHODS

=head2 linear

Populate from C<items> each time.

See L<< C<Set::Associate::B<RefillItems::Linear>>|Set::Associate::RefillItems::Linear >> for details.

    my $sa = Set::Associate->new(
        ...
        on_items_empty => Set::Associate::RefillItems->linear( items => [ ... ])
    );

or ...

    use Set::Associate::RefillItems::Linear;
    my $sa = Set::Associate->new(
        ...
        on_items_empty => Set::Associate::RefillItems::Linear->new( items => [ ... ])
    );

=head2 shuffle

Populate with a shuffled version of C<items>

See L<< C<Set::Associate::B<RefillItems::Shuffle>>|Set::Associate::RefillItems::Shuffle >> for details.

    my $sa = Set::Associate->new(
        ...
        on_items_empty => Set::Associate::RefillItems->shuffle( items => [ ... ]);
    );

or ...

    use Set::Associate::RefillItems::Shuffle;
    my $sa = Set::Associate->new(
        ...
        on_items_empty => Set::Associate::RefillItems::Shuffle->new( items => [ ... ])
    );

=head1 ATTRIBUTES

=head2 name

=head2 code

=head2 items

=head1 ATTRIBUTE HANDLES

=head2 get_all

Invokes C<Trait:Code/execute_method> on L</code>

=head2 has_items

Predicate method for L</items>

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
