use v5.16;
use warnings;

package Set::Associate::NewKey {

  # ABSTRACT: New Key assignment methods
  

=method linear_wrap

C<shift>'s the first item off the internal C<_items_cache>

    my $code = linear_wrap();
    my $newval = $code->( $set );

=cut

  sub linear_wrap {
    return sub {
      my ( $self, ) = @_;
      return $self->_items_cache_shift;
    };
  }

=method random_pick

non-destructively picks an element from C<_items_cache> at random.

    my $code = random_pick();
    my $newval = $code->( $set );


=cut

  sub random_pick {
    return sub {
      my ( $self, ) = @_;
      return $self->_items_cache_get( int( rand( $self->_items_cache_count ) ) );
    };
  }

=method pick_offset

Assuming offset is numeric, pick either that number, or a modulo of that number.

    my $code = pick_offset();
    my $newval = $code->( $set, 9001 ); # despite picking numbers OVER NINE THOUSAND
                                        # will still return items in the array

=cut

  sub pick_offset {
    return sub {
      my ( $self, $offset ) = @_;
      use bigint;
      return $self->_items_cache_get( $offset % $self->_items_cache_count );
    };
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
    return sub {
      my ( $self, $key ) = @_;
      use bigint;
      return $pick_offset->( $self, hex( Digest::SHA1::sha1_hex($key) ) );
    };
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
    return sub {
      my ( $self, $key ) = @_;
      use bigint;
      return $pick_offset->( $self, hex( Digest::MD5::md5_hex($key) ) );
    };
  }
}

1;
