use v5.16;
use warnings;

package Set::Associate::NewKey {

  # ABSTRACT: New Key assignment methods

  use Moo;
  has name => (
    isa => sub { die 'should be Str' if ref $_[0] },
    is       => rwp =>,
    required => 1,
  );
  has code => (
    isa => sub { die 'should be CodeRef' unless ref $_[0] and ref $_[0] eq 'CODE' },
    is       => rwp =>,
    required => 1,
  );

  sub run {
    my ( $self, $sa, $key ) = @_;
    die if not ref $sa;
    $self->code->( $sa, $key );
  }

  no Moo;

=method linear_wrap

C<shift>'s the first item off the internal C<_items_cache>

    my $code = linear_wrap();
    my $newval = $code->( $set );

=cut

  sub linear_wrap {
    return __PACKAGE__->new(
      name => 'linear_wrap',
      code => sub {
        my ( $self, ) = @_;
        return $self->_items_cache_shift;
      }
    );
  }

=method random_pick

non-destructively picks an element from C<_items_cache> at random.

    my $code = random_pick();
    my $newval = $code->run( $set );


=cut

  sub random_pick {
    return __PACKAGE__->new(
      name => 'random_pick',
      code => sub {
        my ( $self, ) = @_;
        return $self->_items_cache_get( int( rand( $self->_items_cache_count ) ) );
      }
    );
  }

=method pick_offset

Assuming offset is numeric, pick either that number, or a modulo of that number.

    my $code = pick_offset();
    my $newval = $code->run( $set, 9001 ); # despite picking numbers OVER NINE THOUSAND
                                        # will still return items in the array

=cut

  sub pick_offset {
    return __PACKAGE__->new(
      name => 'pick_offset',
      code => sub {
        my ( $self, $offset ) = @_;
        use bigint;
        return $self->_items_cache_get( $offset % $self->_items_cache_count );
      }
    );
  }

=method hash_sha1

B<requires bigint support>

Determines the offset for L</pick_offset> from taking the numeric value of the SHA1 hash of the given string

    my $code = hash_sha1();
    my $newval = $code->( $set, "Some String" );

=cut

  sub hash_sha1 {
    require Digest::SHA1;
    my $pick_offset = pick_offset();
    return __PACKAGE__->new(
      name => 'hash_sha1',
      code => sub {
        my ( $self, $key ) = @_;
        use bigint;
        return $pick_offset->run( $self, hex Digest::SHA1::sha1_hex($key) );
      }
    );
  }

=method hash_md5

B<requires bigint support>

Determines the offset for L</pick_offset> from taking the numeric value of the MD5 hash of the given string

    my $code = hash_md5();
    my $newval = $code->( $set, "Some String" );

=cut

  sub hash_md5 {
    require Digest::MD5;
    my $pick_offset = pick_offset();
    return __PACKAGE__->new(
      name => 'hash_md5',
      code => sub {
        my ( $self, $key ) = @_;
        use bigint;
        return $pick_offset->run( $self, hex Digest::MD5::md5_hex($key) );
      }
    );
  }
};

1;
