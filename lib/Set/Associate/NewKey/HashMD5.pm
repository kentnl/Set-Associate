use v5.16;
use warnings;

package Set::Associate::NewKey::HashMD5 {

  use Moose;
  use Digest::MD5;
  extends 'Set::Associate::NewKey::PickOffset';

  sub name { 'hash_sha1' }

  around get_assoc => sub {
    my ( $orig, $self, $sa, $key ) = @_;
    use bigint;
    return $self->$orig( $sa, hex Digest::MD5::md5_hex($key) );
  };

  __PACKAGE__->meta->make_immutable;
}

1;

