use v5.16;
use warnings;

package Set::Associate::NewKey::LinearWrap {

  # ABSTRACT: destructively empty the supply pool from the left hand end to give associations.
  use Moose;

  with 'Set::Associate::Role::NewKey' => { can_get_assoc => 1, };

  sub name { 'linear_wrap' }

  sub get_assoc {
    my ( $self, $sa, $key ) = @_;
    return $sa->_items_cache_shift;
  }

  __PACKAGE__->meta->make_immutable;
}

1;

