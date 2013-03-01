use v5.16;
use warnings;

package Set::Associate::NewKey::RandomPick {

  # ABSTRACT: Associate a key by randomly picking from a pool

  use Moose;

  with 'Set::Associate::Role::NewKey' => { can_get_assoc => 1, };

  sub name { 'random_pick' }

  sub get_assoc {
    my ( $self, $sa, $key ) = @_;
    return $sa->_items_cache_get( int( rand( $sa->_items_cache_count ) ) );
  }

  __PACKAGE__->meta->make_immutable;
}

1;

