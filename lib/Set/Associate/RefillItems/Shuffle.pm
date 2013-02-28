use v5.16;
use warnings;

package Set::Associate::RefillItems::Shuffle {

  use Moose;

  with 'Set::Associate::Role::RefillItems' => { can_get_all => 1, };

  has items => ( isa => 'ArrayRef', is => 'rw', required => 1 );

  sub name { 'shuffle' }

  use List::Util qw( shuffle );

  sub get_all { return shuffle( @{ $_[0]->items } ) }

  __PACKAGE__->meta->make_immutable;
};

1;

