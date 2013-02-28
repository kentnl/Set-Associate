use v5.16;
use warnings;

package Set::Associate::RefillItems::Linear {

  use Moose;

  with 'Set::Associate::Role::RefillItems' => { can_get_all => 1 };

  has items => ( isa => 'ArrayRef', is => 'rw', required => 1 );

  sub name { 'linear' }

  sub get_all { return @{ $_[0]->items } }

  __PACKAGE__->meta->make_immutable;
};

1;

