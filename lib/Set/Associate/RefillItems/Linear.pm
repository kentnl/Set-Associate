use 5.006;
use strict;
use warnings;

package Set::Associate::RefillItems::Linear;

# ABSTRACT: a refill method that replenishes the cache with a repeating set of items

our $VERSION = '0.004000';

# AUTHORITY

use Moose;

with 'Set::Associate::Role::RefillItems' => { can_get_all => 1 };

=carg items

    required ArrayRef

=attr items

=cut

has items => ( isa => 'ArrayRef', is => 'rw', required => 1 );

=method name

The name of this refill method ( C<linear> )

=cut

sub name { 'linear' }

=method get_all

Get a new copy of L</items>.

=cut

sub get_all { return @{ $_[0]->items } }

__PACKAGE__->meta->make_immutable;

1;

