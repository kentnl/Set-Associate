use 5.006;
use strict;
use warnings;

package Set::Associate::NewKey::LinearWrap;

# ABSTRACT: destructively empty the supply pool from the left hand end to give associations.
use Moose;

with 'Set::Associate::Role::NewKey' => { can_get_assoc => 1, };

=method name

The name of this key assignment method ( C<linear_wrap> )

=cut

sub name { 'linear_wrap' }

=method get_assoc

Returns a value destructively by taking the first value from C<$set_assoc>'s pool.

C<$new_key> is ignored with this method.

   my $value = $object->get_assoc( $set_assoc, $new_key );

=cut

sub get_assoc {
  my ( $self, $sa, $key ) = @_;
  return $sa->_items_cache_shift;
}

__PACKAGE__->meta->make_immutable;

1;

