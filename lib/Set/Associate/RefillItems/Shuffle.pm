use v5.16;
use warnings;

package Set::Associate::RefillItems::Shuffle {

  # ABSTRACT: a refill method that replenishes the cache with a shuffled list

  use Moose;

  with 'Set::Associate::Role::RefillItems' => { can_get_all => 1, };

=carg items

    required ArrayRef

=attr items

=cut

  has items => ( isa => 'ArrayRef', is => 'rw', required => 1 );

=method name

The name of this refill method ( C<shuffle> )

=cut

  sub name { 'shuffle' }

  use List::Util qw( shuffle );

=method get_all

Get a new copy of C<items> in shuffled form.

=cut

  sub get_all { return shuffle( @{ $_[0]->items } ) }

  __PACKAGE__->meta->make_immutable;
};

1;

