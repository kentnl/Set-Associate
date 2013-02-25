use v5.16;
use warnings;

package Set::Associate::NewKey {
BEGIN {
  $Set::Associate::NewKey::AUTHORITY = 'cpan:KENTNL';
}

{
  $Set::Associate::NewKey::VERSION = '0.001001';
}


  # ABSTRACT: New Key assignment methods


  use Moo;

  sub _croak {
    require Carp;
    goto \&Carp::croak;
  }


  has name => (
    isa => sub { _croak('should be Str') if ref $_[0] },
    is       => rwp =>,
    required => 1,
  );


  has code => (
    isa => sub { _croak('should be CodeRef') unless ref $_[0] and ref $_[0] eq 'CODE' },
    is       => rwp =>,
    required => 1,
  );


  sub run {
    my ( $self, $sa, $key ) = @_;
    _croak('->run(x,y), x should be a ref') if not ref $sa;
    $self->code->( $sa, $key );
  }

  no Moo;


  sub linear_wrap {
    return __PACKAGE__->new(
      name => 'linear_wrap',
      code => sub {
        my ( $self, ) = @_;
        return $self->_items_cache_shift;
      }
    );
  }


  sub random_pick {
    return __PACKAGE__->new(
      name => 'random_pick',
      code => sub {
        my ( $self, ) = @_;
        return $self->_items_cache_get( int( rand( $self->_items_cache_count ) ) );
      }
    );
  }


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

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate::NewKey - New Key assignment methods

=head1 VERSION

version 0.001001

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

=head1 CONSTRUCTOR ARGUMENTS

=head2 name

    required Str

=head2 code

    required CodeRef

=head1 CLASS METHODS

=head2 linear_wrap

C<shift>'s the first item off the internal C<_items_cache>

    my $sa = Set::Associate->new(
        ...
        on_new_key => Set::Associate::NewKey::linear_wrap
    );

or alternatively

    my $code = Set::Associate::NewKey::linear_wrap
    my $newval = $code->run( $set, $key_which_will_be_ignored );

You can use C<< -> >> or not if you want, nothing under the hood cares.

=head2 random_pick

non-destructively picks an element from C<_items_cache> at random.

    my $sa = Set::Associate->new(
        ...
        on_new_key => Set::Associate::NewKey::random_pick
    );

or alternatively

    my $code = Set::Associate::NewKey::random_pick
    my $newval = $code->run( $set, $key_which_will_be_ignored );

You can use C<< -> >> or not if you want, nothing under the hood cares.

=head2 pick_offset

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

=head2 hash_sha1

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

=head2 hash_md5

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

=head1 METHODS

=head2 run

runs code attached via L</code>

    my $value = $object->run( $set_associate_object , $key );

And C<$value> is the newly formed associaiton value.

=head1 ATTRIBUTES

=head2 name

=head2 code

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
