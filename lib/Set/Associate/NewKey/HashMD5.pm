use 5.006;
use strict;
use warnings;

package Set::Associate::NewKey::HashMD5;

# ABSTRACT: Pick a value from the pool based on the MD5 value of the key

our $VERSION = '0.004000';

# AUTHORITY

use Moose qw( around extends );
use Digest::MD5;
use bigint 0.22 qw( hex );
extends 'Set::Associate::NewKey::PickOffset';

=method name

The name of this key assignment method ( C<hash_md5> )

=cut

sub name { 'hash_md5' }
around get_assoc => sub {
  my ( $orig, $self, $sa, $key ) = @_;

  return $self->$orig( $sa, hex Digest::MD5::md5_hex($key) );
};

__PACKAGE__->meta->make_immutable;

no Moose;

1;

