use 5.006;
use strict;
use warnings;

package Set::Associate::NewKey::RandomPick;

# ABSTRACT: Associate a key by randomly picking from a pool

our $VERSION = '0.004000';

# AUTHORITY

use Moose qw( with );

with 'Set::Associate::Role::NewKey' => { can_get_assoc => 1, };

__PACKAGE__->meta->make_immutable;

no Moose;

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
  return $_[1]->_items_cache_get( int( rand( $_[1]->_items_cache_count ) ) );
}

1;

