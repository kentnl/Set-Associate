use v5.16;
use warnings;

package Set::Associate::NewKey::PickOffset {

  use Moose;

  with 'Set::Associate::Role::NewKey' => { can_get_assoc => 1, };

  sub name { 'pick_offset' }

  sub get_assoc {
    my ( $self, $sa, $key ) = @_;
    use bigint;
    return $sa->_items_cache_get( $key % $sa->_items_cache_count );
  }

  __PACKAGE__->meta->make_immutable;
}

1;

