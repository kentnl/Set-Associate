use v5.16;
use warnings;

package Set::Associate::NewKey::HashSHA1 {

  # ABSTRACT: Pick a value from the pool based on the C<SHA1> value of the key

  use Moose;
  use Digest::SHA1;
  extends 'Set::Associate::NewKey::PickOffset';

=method name

The name of this key assignment method ( C<hash_sha1> )

=cut

  sub name { 'hash_sha1' }

  around get_assoc => sub {
    my ( $orig, $self, $sa, $key ) = @_;
    use bigint;
    return $self->$orig( $sa, hex Digest::SHA1::sha1_hex($key) );
  };

  __PACKAGE__->meta->make_immutable;
};

1;

