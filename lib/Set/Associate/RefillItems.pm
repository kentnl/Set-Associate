use v5.16;
use warnings;

package Set::Associate::RefillItems {

  # ABSTRACT: Pool re-population methods
  use Moose;
  use MooseX::AttributeShortcuts;

  use Set::Associate::Utils;
  *_warn_nonmethod = *Set::Associate::Utils::_warn_nonmethod;

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

=carg name

    required Str

=attr name

=cut

  has name => (
    isa      => Str =>,
    is       => rwp =>,
    required => 1,
  );

=carg code

    required CodeRef

=attr code

=ahandle get_all

Invokes C<Trait:Code/execute_method> on L</code>

=cut

  has code => (
    isa      => CodeRef =>,
    is       => rwp     =>,
    required => 1,
    traits   => ['Code'],
    handles  => {
      get_all => execute_method =>,
    },
  );

=carg items

    required ArrayRef

=attr items

=ahandle has_items

Predicate method for L</items>

=cut

  has items => (
    isa       => ArrayRef  =>,
    is        => rwp       =>,
    predicate => has_items =>,
  );

  with 'Set::Associate::Role::RefillItems' => { can_get_all => 1, };

  __PACKAGE__->meta->make_immutable;

=cmethod linear

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

=cut

  sub linear {
    if ( _warn_nonmethod( $_[0], __PACKAGE__, 'linear' ) ) {
      unshift @_, __PACKAGE__;
    }
    my ( $class, @args ) = @_;
    require Set::Associate::RefillItems::Linear;
    return Set::Associate::RefillItems::Linear->new(@args);
  }

=cmethod shuffle

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
    
=cut

  sub shuffle {
    if ( _warn_nonmethod( $_[0], __PACKAGE__, 'shuffle' ) ) {
      unshift @_, __PACKAGE__;
    }
    my ( $class, @args ) = @_;
    require Set::Associate::RefillItems::Shuffle;
    return Set::Associate::RefillItems::Shuffle->new(@args);
  }
};

1;
