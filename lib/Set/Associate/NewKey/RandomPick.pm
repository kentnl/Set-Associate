use v5.16;
use warnings;

package Set::Associate::NewKey::RandomPick {

  # ABSTRACT: Associate a key by randomly picking from a pool

  use Moose;

  with 'Set::Associate::Role::NewKey' => { can_get_assoc => 1, };

=method name

The name of this key assignment method ( C<random_pick> )

=cut

  sub name { 'random_pick' }

=method get_assoc

Returns a value non-destructively at random from C<$set_assoc>'s pool.

C<$new_key> is ignored with this method.

   my $value = $object->get_assoc( $set_assoc, $new_key );

=cut

  sub get_assoc {
    my ( $self, $sa, $key ) = @_;
    return $sa->_items_cache_get( int( rand( $sa->_items_cache_count ) ) );
  }

  __PACKAGE__->meta->make_immutable;
};

1;

