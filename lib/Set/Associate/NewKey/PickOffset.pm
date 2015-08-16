use 5.006;
use strict;
use warnings;

package Set::Associate::NewKey::PickOffset;

# ABSTRACT: Associate a key with a value from a pool based on the keys value as a numeric offset.

our $VERSION = '0.004000';

# AUTHORITY

use Moose;

with 'Set::Associate::Role::NewKey' => { can_get_assoc => 1, };

=method name

The name of this key assignment method ( C<pick_offset> )

=cut

sub name { 'pick_offset' }

=method get_assoc

Returns a value non-destructively by picking an item at numerical offset C<$new_key>

   my $value = $object->get_assoc( $set_assoc, $new_key );

B<Note:> C<$new_key> is automatically modulo  of the length of C<$set_assoc>, so offsets beyond end of array are safe, and wrap.

=cut

sub get_assoc {
  my ( $self, $sa, $key ) = @_;
  use bigint;
  return $sa->_items_cache_get( $key % $sa->_items_cache_count );
}

__PACKAGE__->meta->make_immutable;

1;

