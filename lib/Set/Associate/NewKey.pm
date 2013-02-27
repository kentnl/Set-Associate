use v5.16;
use warnings;

package Set::Associate::NewKey {

  # ABSTRACT: New Key assignment methods

=head1 DESCRIPTION

This class implements the mechanism which controls how the values are assigned to 'new' keys.

The part you're mostly interested in are the L</CLASS METHODS>, which return the right populator.

This is more or less a wrapper for passing around subs with an implict interface.

    my $assigner = Set::Associate::NewKey->new(
        name => 'linear_wrap',
        code => sub {
            my ( $self, $sa , $key ) = @_;
            ....
        },
    );

    my $value = $assigner->run( $set_associate_object, $key );

=cut

  use Moo;
  use Set::Associate::Utils;

  *_croak      = *Set::Associate::Utils::_croak;
  *_tc_str     = *Set::Associate::Utils::_tc_str;
  *_tc_coderef = *Set::Associate::Utils::_tc_coderef;

=carg name

    required Str

=attr name

=cut

  has name => (
    isa      => \&_tc_str,
    is       => rwp =>,
    required => 1,
  );

=carg code

    required CodeRef

=attr code

=cut

  has code => (
    isa      => \&_tc_coderef,
    is       => rwp =>,
    required => 1,
  );

=method run

runs code attached via L</code>

    my $value = $object->run( $set_associate_object , $key );

And C<$value> is the newly formed associaiton value.

=cut

  sub run {
    my ( $self, $sa, $key ) = @_;
    _croak('->run(x,y), x should be a ref') if not ref $sa;
    $self->code->( $sa, $key );
  }

  no Moo;

=cmethod linear_wrap

C<shift>'s the first item off the internal C<_items_cache>


    my $sa = Set::Associate->new(
        ...
        on_new_key => Set::Associate::NewKey::linear_wrap
    );

or alternatively

    my $code = Set::Associate::NewKey::linear_wrap
    my $newval = $code->run( $set, $key_which_will_be_ignored );


You can use C<< -> >> or not if you want, nothing under the hood cares.

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

=cmethod random_pick

non-destructively picks an element from C<_items_cache> at random.

    my $sa = Set::Associate->new(
        ...
        on_new_key => Set::Associate::NewKey::random_pick
    );

or alternatively

    my $code = Set::Associate::NewKey::random_pick
    my $newval = $code->run( $set, $key_which_will_be_ignored );

You can use C<< -> >> or not if you want, nothing under the hood cares.

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

=cmethod pick_offset

Assuming offset is numeric, pick either that number, or a modulo of that number.

B<NOTE:> do not use this unless you are only working with numeric keys.

If you're using anything else, the hash_sha1 or hash_md5 methods are suggested.

    my $sa = Set::Associate->new(
        ...
        on_new_key => Set::Associate::NewKey::pick_offset
    );

or alternatively

    my $code = Set::Associate::NewKey::pick_offset
    my $newval = $code->run( $set, 9001 ); # despite picking numbers OVER NINE THOUSAND
                                           # will still return items in the array


You can use C<< -> >> or not if you want, nothing under the hood cares.

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

=cmethod hash_sha1

B<requires bigint support>

Determines the offset for L</pick_offset> from taking the numeric value of the SHA1 hash of the given string

    my $sa = Set::Associate->new(
        ...
        on_new_key => Set::Associate::NewKey::hash_sha1
    );

or alternatively

    my $code = Set::Associate::NewKey::hash_sha1();
    my $newval = $code->run( $set, "Some String" );

You can use C<< -> >> or not if you want, nothing under the hood cares.

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

=cmethod hash_md5

B<requires bigint support>

Determines the offset for L</pick_offset> from taking the numeric value of the MD5 hash of the given string

    my $sa = Set::Associate->new(
        ...
        on_new_key => Set::Associate::NewKey::hash_md5
    );

or alternatively

    my $code = Set::Associate::NewKey::hash_md5();
    my $newval = $code->run( $set, "Some String" );

You can use C<< -> >> or not if you want, nothing under the hood cares.

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
