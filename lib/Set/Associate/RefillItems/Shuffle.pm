use 5.006;
use strict;
use warnings;

package Set::Associate::RefillItems::Shuffle;

# ABSTRACT: a refill method that replenishes the cache with a shuffled list

our $VERSION = '0.004000';

# AUTHORITY

use Moose qw( with has );

with 'Set::Associate::Role::RefillItems' => { can_get_all => 1, };

=carg items

    required ArrayRef

=attr items

=cut

has items => ( isa => 'ArrayRef', is => 'rw', required => 1 );

__PACKAGE__->meta->make_immutable;

no Moose;

=method name

The name of this refill method ( C<shuffle> )

=cut

sub name { 'shuffle' }

use List::Util qw( shuffle );

=method get_all

Get a new copy of C<items> in shuffled form.

=cut

sub get_all { return shuffle( @{ $_[0]->items } ) }

1;

